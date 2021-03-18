class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def edit; end

  def create
    @answer = question.answers.create(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully created'
    else
      render 'questions/show'
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
    if current_user.author_of?(answer)
      answer.destroy
      flash_options = { notice: 'Answer successfully deleted' }
    else
      flash_options = { notice: 'Only author can delete his answers' }
    end
    redirect_to question_path(answer.question), flash_options
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
