class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "Intercepted Dev Email (Originally To: #{message.to}. Original Subject: #{message.subject})"
    message.to = 'paynmatt@gmail.com'
  end
end