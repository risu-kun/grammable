class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    @gram = Gram.find_by_id(params[:gram_id])

    if @gram.nil?
      render_unsuccessful
    else
      @comment = @gram.comments.create(comment_params)
      if @comment.valid?
      redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end    
    end    
  end

  private
  def comment_params
    params.require(:comment).permit(:message)
  end

  def render_unsuccessful(status=:not_found)
    render text: '#{status.to_s.titlize} :(', status: status
  end
end
