require 'active_record'
require 'silent_fail_logger'

module SilentFailCheck
  CheckParameters = Struct.new(:sym, :args, :block)

  def silent_fail_check sym, *args, &block
    extend  ClassMethods
    include InstanceMethods

    @check_parameters = CheckParameters.new(sym, args, block)
    method_name = "add_#{sym}_fail_check"
    send(method_name) if respond_to?(method_name, true)
  end

  module ClassMethods

    private

    def check_parameters
      @check_parameters
    end

    def add_validation_fail_check
      after_validation "#{check_parameters.sym}_fail_check"
    end
  end

  module InstanceMethods

    private

    def validation_fail_check
      p = self.class.send(:check_parameters)

      if p.block.nil?
        p.args.each do |a|
          SilentFailLogger.add("#{self.class} : #{a} #{self.errors[a]}") if self.errors[a].present?
        end
      else
        p.args.collect &p.block
      end
    end
  end
end

ActiveRecord::Base.extend SilentFailCheck
