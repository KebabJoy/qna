class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link

    @linkable = @link.linkable

    @link.destroy
  end
end
