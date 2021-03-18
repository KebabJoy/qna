class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @answers = Answer.all
  end

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to question_answers_path(question)
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
