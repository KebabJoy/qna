# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController


      def me
        authorize! :me, User
        render json: current_resource_owner
      end

      def index
        @users = User.all_except(current_resource_owner)
        render json: @users
      end
    end
  end
end
