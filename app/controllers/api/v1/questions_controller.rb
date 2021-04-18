# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController

      before_action :set_question, only: %i[show update destroy]
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: @question
      end

      def create
        @question = current_resource_owner.authored_questions.new(question_params)

        if @question.save
          render json: @question
        else
          head :precondition_failed
        end
      end

      def update
        if @question.update(question_params)
          render json: @question
        else
          head :precondition_failed
        end
      end

      def destroy
        @question.destroy
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end

      def set_question
        @question = Question.find(params[:id])
      end
    end
  end
end
