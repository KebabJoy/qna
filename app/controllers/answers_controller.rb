class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_user

    @answer.save
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    answer.destroy if current_user&.author_of?(answer)
  end


  private

  def answer_params
    params.require(:answer).permit(:body)
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
