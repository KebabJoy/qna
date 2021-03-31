class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    @linkable = @link.linkable

    if current_user.author_of?(@linkable)
      @link.destroy
    else
      head :forbidden
    end
  end
end
