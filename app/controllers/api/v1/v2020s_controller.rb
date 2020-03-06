# frozen_string_literal: true

module Api
  module V1
    class V2020sController < ApplicationController
      include AuditLog

      before_action :set_meta
      before_action :set_current_user, only: [:voting_districts]
      before_action :set_district, only: [:voting_districts]

      # city list
      def cities
        @cities = City.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@cities).merge(meta_status)
      end

      # voting district list
      def voting_districts
        @liked_candidates = @current_user.liked_candidates.pluck('id')

        @voting_districts = @district.present?? VotingDistrict.where(id: @district) : VotingDistrict.all
        @voting_districts = @voting_districts.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@voting_districts).merge(meta_status)
      end

      private

      def set_current_user
        @current_user = User.find_by(device_id: request.headers[:HTTP_DEVICE_ID])
      end

    end
  end
end

