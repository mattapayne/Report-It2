class SnippetsController < ApplicationController
  before_action :require_login
  before_action :load_snippet, only: [:update, :destroy]
  
  def index
    render json: current_user.snippets.to_a
  end
  
  def create
    @snippet = current_user.snippets.build(params_for_snippet)
    if @snippet.save
      render json: { messages: ["Successfully create the snippet: #{@snippet.name}"], snippet: @snippet }
    else
      render json: { messages: @snippet.errors.full_messages.to_a }, status: 406
    end
  end
  
  def update
    if @snippet
      if @snippet.update_attributes(params_for_snippet)
        render json: { messages: ["Successfully updated the snippet: #{@snippet.name}"] }
      else
        render json: { messages: @snippet.errors.full_messages.to_a }, status: 406
      end
    else
      render json: { messages: ['Unable to find that snippet.'] }, status: 404
    end
  end
  
  def destroy
    if @snippet
      if @snippet.delete
        render json: { messages: ["Successfully deleted the snippet: #{@snippet.name}"] }
      else
        render json: { messages: @snippet.errors.full_messages.to_a }, status: 406
      end
    else
      render json: { messages: ['Unable to find that snippet.'] }, status: 404
    end
  end

  private
  
  def params_for_snippet
    params.require(:snippet).permit(:name, :content)
  end
  
  def load_snippet
    @snippet = current_user.snippets.find(params[:id])
  end
end
