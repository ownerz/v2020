# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_meta

      def create
        @user = User.new(user_params)
        @user.save!

        # if @user.save
        #   render_response(resource: {data: @user})
        # else
        #   render_error :unprocessable_entity, @user.errors
        # end
      rescue => e
        render_error :unprocessable_entity, e
      end

      private

      def user_params
        params.require(:data)
            .permit(:device_id, :age, :sex, :latitude, :longitude)
      end
    end
  end
end

