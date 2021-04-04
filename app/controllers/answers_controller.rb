class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_answer, only: :create

  include Voted

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_user
    @comment = Comment.new

    @answer.save
  end

  def update
    answer.update(answer_params) if current_user&.author_of?(answer)
  end

  def destroy
    answer.destroy if current_user&.author_of?(answer)
  end

  def make_best
    question = answer.question
    return head(:forbidden) unless current_user&.author_of?(question)

    answer.best!
    @answers = question.answers
  end


  private

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast("question_#{question.id}/answers", answer)
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :question
  helper_method :answer
end
