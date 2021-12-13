class CommentsController < ApplicationController
  authorize_resource
  
  before_action :set_commentable, only: :create
  before_action :find_comment, only: %i[update destroy]

  def create
    @comment = @commentable.comments.new(comments_params.merge(author: current_user))

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment, include: :author }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comments_params)
        format.json { render json: @comment, include: :author }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    render json: { message: "Comment has been deleted." }
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params["#{commentable_name.singularize}_id"])
  end

  def commentable_name
    params[:commentable]
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end