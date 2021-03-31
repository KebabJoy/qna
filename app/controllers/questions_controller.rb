class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    question
    @answer ||= Answer.new
    @answer.links.new
    @answers = question.answers
    @badge = question.badge
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.authored_questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user&.author_of?(question)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash_options = { notice: 'Question destroyed successfully' }
    else
      flash_options = { notice: 'Only author can delete his questions' }
    end
    redirect_to questions_path, flash_options
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url],
                                                    badge_attributes: %i[name img_url])
  end
end
