# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController


      def me
        authorize! :me, User
        render json: current_resource_owner
      end
    end
  end
end
