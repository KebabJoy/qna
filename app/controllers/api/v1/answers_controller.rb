module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :set_question, only: %i[index create]
      before_action :set_answer, only: %i[show update]

      authorize_resource

      def index
        render json: @question.answers
      end

      def show
        render json: @answer
      end

      def create
        @answer = @question.answers.new(answer_params)
        @answer.author = current_resource_owner

        if @answer.save
          render json: @answer
        else
          head :precondition_failed
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer
        else
          head :precondition_failed
        end
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end

      def set_answer
        @answer = Answer.find(params[:id])
      end

      def set_question
        @question = Question.find(params[:question_id])
      end
    end
  end
end
