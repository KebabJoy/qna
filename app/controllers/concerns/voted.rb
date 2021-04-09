module Voted
  extend ActiveSupport::Concern

  def vote_for
    authorize! :vote_for, votable
    votable.upvote(current_user)

    respond_to do |format|
      if votable.save
        format.json do
          render json: { score: votable.votes_sum,
                         votable_type: votable.class.name,
                         votable_id: votable.id }
        end
      else
        format.json do
          render json: { errors: votable.errors.full_messages,
                         votable_type: votable.class.name,
                         votable_id: votable.id }, status: :forbidden
        end
      end
    end
  end

  def vote_against
    authorize! :vote_against, votable
    votable.vote_down(current_user)

    respond_to do |format|
      if votable.save
        format.json do
          render json: { score: votable.votes_sum,
                         votable_type: votable.class.name,
                         votable_id: votable.id }
        end
      else
        format.json do
          render json: { errors: votable.errors.full_messages,
                         votable_type: votable.class.name,
                         votable_id: votable.id }, status: :forbidden
        end
      end
    end
  end

  def cancel_vote
    authorize! :cancel_vote, votable

    votable.undo_vote(current_user)

    respond_to do |format|
      format.json do
        render json: { score: votable.votes_sum,
                       votable_type: votable.class.name,
                       votable_id: votable.id }
      end
    end
  end

  private

  def votable
    @votable ||= model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
