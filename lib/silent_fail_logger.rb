class SilentFailLogger
  @@options = {}
  @@is_configured = false

  def self.configure opts={}
    @@options[:model] = opts[:model] || SilentFailLog
    @@options[:message] = opts[:message] || 'message'
    @@is_configured = true
  end

  def self.add message
    self.configure if !@is_configured
    @@options[:model].send(:create, @@options[:message].to_sym => message)
  end
end