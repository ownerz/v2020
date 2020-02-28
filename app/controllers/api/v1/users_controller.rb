# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_meta
      before_action :set_current_user, only: %i[like]

      def create
        @current_user = User.new(user_params)
        @current_user.save!

      rescue => e
        render_error :unprocessable_entity, e
      end

      def like_candidate
        @current_user.add_like_to(Candidate.find(like_params.dig('candidate_id')))
      rescue => e
        render_error :unprocessable_entity, e
      end

      private

      def set_current_user
        @current_user = User.find_by!(device_id: request.headers['device-id'])
      rescue
        render_error :unprocessable_entity, 'current_user not found'
      end

      def like_params
        params.require(:data)
            .permit(:candidate_id)
      end

      def user_params
        params.require(:data)
            .permit(:device_id, :age, :sex, :latitude, :longitude)
      end
    end
  end
end

