module Voted
  extend ActiveSupport::Concern

  def vote_for
    votable.upvote(current_user)

    respond_to do |format|
      if votable.save
        format.json { render json: votable.votes_sum }
      else
        format.json { render json: votable.errors.full_messages, status: :forbidden }
      end
    end
  end

  def vote_against
    votable.vote_down(current_user)

    respond_to do |format|
      if votable.save
        format.json { render json: votable.votes_sum }
      else
        format.json { render json: votable.errors.full_messages, status: :forbidden }
      end
    end
  end

  def cancel_vote
    votable.undo_vote(current_user)

    respond_to do |format|
      format.json { render json: votable.votes_sum }
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
