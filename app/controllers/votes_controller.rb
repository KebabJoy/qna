class VotesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
end
