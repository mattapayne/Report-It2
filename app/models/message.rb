class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :from
  field :email
  field :subject
  field :message_text
  
  validates_presence_of :message_text, :subject, :email, :from
  validates_format_of :email, with: Mongoid::Document::email_regex, on: :create
end
