# frozen_string_literal: true

module Api
  module V1
    class V2020sController < ApplicationController
      include AuditLog

      before_action :set_meta
      before_action :set_current_user, only: [:voting_districts, :show]
      before_action :set_district, only: [:voting_districts, :district_by_location]

      # city list
      def cities
        @cities = City.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@cities).merge(meta_status)
      end

      # voting district list
      def voting_districts
        @liked_candidates = @current_user.liked_candidates.pluck('id')

        if params[:keyword].present?
          @voting_districts = VotingDistrict.search_by_keyword(params[:keyword])
        else
          @voting_districts = @district.present?? VotingDistrict.where(id: @district) : VotingDistrict.all
        end
        @voting_districts = @voting_districts.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@voting_districts).merge(meta_status)
      end

      def show
        @liked_candidates = @current_user.liked_candidates.pluck('id')
        @voting_district = VotingDistrict.where(id: params[:id])
      end

      # 위치 정보로 지역 아이디 받아오기
      def district_by_location
        @district.present?? VotingDistrict.where(id: @district)&.first : VotingDistrict.find(22)
        render json: { district: @district, meta: @meta }, adapter: :json
      end


      private

      def set_current_user
        @current_user = User.find_by(device_id: request.headers[:HTTP_DEVICE_ID])
      end

    end
  end
end

