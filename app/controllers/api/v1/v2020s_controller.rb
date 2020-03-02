# frozen_string_literal: true

module Api
  module V1
    class V2020sController < ApplicationController
      include AuditLog

      before_action :set_meta
      before_action :set_district, only: [:voting_districts]

      # city list
      def cities
        @cities = City.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@cities).merge(meta_status)
      end

      # voting district list
      def voting_districts
        @voting_districts = @district.present?? VotingDistrict.where(id: @district) : VotingDistrict.all
        @voting_districts = @voting_districts.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@voting_districts).merge(meta_status)
      end

    end
  end
end

