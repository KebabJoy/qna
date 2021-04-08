class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link

    @linkable = @link.linkable

    if current_user.author_of?(@linkable)
      @link.destroy
    else
      head :forbidden
    end
  end
end
