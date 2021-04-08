class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.author = current_user

    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    question_id = commentable.is_a?(Question) ? commentable.id : commentable.question.id
    ActionCable.server.broadcast("question_#{question_id}/comments", @comment)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end

  helper_method :commentable
end
