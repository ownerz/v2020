# frozen_string_literal: true

module Api
  module V1
    class V2020sController < ApplicationController
      before_action :set_meta
      before_action :get_district, only: [:candidates]

      # # candidate list
      # def candidates
      #   candidate = Candidate.last
      #   @candidates = @district.present?? Candidate.where(voting_district: @district) : Candidate.all
      #   # @candidates = @candidates.where(crawl_id: candidate&.crawl_id)
      #   @candidates = @candidates.page(params[:page]).per(params[:per_page])
      #   @meta = get_page_info(@candidates).merge(meta_status)
      # end

      # city list
      def cities
        @cities = City.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@cities).merge(meta_status)
      end

      # voting district list
      def voting_districts
        @voting_districts = VotingDistrict.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@voting_districts).merge(meta_status)
      end

      # private

      # def get_district
      #   location_string = KakaoLocationService.new.get_location_info(params[:x], params[:y])
      #   return unless location_string.present?

      #   #
      #   # 세종은 특별하다.
      #   # "region_1depth_name"=>"세종특별자치시", "region_2depth_name"=>"세종시", "region_3depth_name"=>"연서면 와촌리"
      #   # 제주도 특별하다.
      #   # "region_1depth_name"=>"제주특별자치도", "region_2depth_name"=>"제주시", "region_3depth_name"=>"애월읍 고성리"
      #   # 

      #   region_1depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_1depth_name')
      #   region_2depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_2depth_name')
      #   region_3depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_3depth_name')
      #   return unless region_1depth_name.present? || region_2depth_name.present?

      #   @district = District.where('name1 like ?', "#{region_3depth_name.split(' ').first}%")&.first&.voting_district
      #   @district = VotingDistrict.where('name1 like ?', "#{region_2depth_name}%") unless @district.present?
      #   @district = VotingDistrict.where('name2 like ?', "#{region_2depth_name}%") unless @district.present?
      #   @district = VotingDistrict.where('name1 like ?', "#{region_1depth_name}%") unless @district.present?
      #   @district = VotingDistrict.where('name2 like ?', "#{region_1depth_name}%") unless @district.present?

      #   Rails.logger.info("get_district) district: #{@district}")
      # end

    end
  end
end

