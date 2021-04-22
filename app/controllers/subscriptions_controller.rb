class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question ||= Question.find(params[:question_id])

    @subscription = Subscription.create(question: @question, user: current_user)

    redirect_to @subscription.question
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    @subscription.destroy

    redirect_to @subscription.question
  end
end
