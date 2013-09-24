class HomeController < ApplicationController
  
  def index

  end
  
  def about
    
  end
  
  def contact
    @message = Message.new
  end
  
  def create
    @message = Message.new(params_for_message)
    if @message.save
      render json: { messages: ["Successfully sent your message."] }, status: 200
    else
      render json: { messages: @message.errors.full_messages.to_a }, status: 406
    end
  end
  
  protected
  
  def get_title(action)
    "#{super} :: #{action.humanize}"
  end
  
  private
  
  def params_for_message
    params.require(:message).permit(:email, :subject, :message_text, :from)
  end
end
