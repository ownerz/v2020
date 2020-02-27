# frozen_string_literal: true

module Api
  module V1
    class CandidatesController < ApplicationController
      before_action :set_meta
      before_action :get_district, only: [:index]

      before_action :set_current_user, only: %i[show_comments create_comments]
      before_action :set_candidate, only: %i[show_comments create_comments show]

      # candidate list
      def index
        # candidate = Candidate.last
        @candidates = @district.present?? Candidate.where(voting_district: @district) : Candidate.all
        # @candidates = @candidates.where(crawl_id: candidate&.crawl_id)
        @candidates = @candidates.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@candidates).merge(meta_status)
      end

      def show; end

      def create_comments
        @current_user.comments.create(comment_params)
        render_response resource: {}, meta: default_meta
      end

      def show_comments
        @comments = @candidate.comments
      end

      private

      def set_current_user
        @current_user = User.find_by!(device_id: request.headers['device-id'])
      rescue
        render_error :unprocessable_entity, 'current_user not found'
      end

      def set_candidate
        @candidate = Candidate.find(params[:id])
      rescue
        render_error :unprocessable_entity, 'candidate not found'
      end

      def comment_params
        params.require(:data)
            .permit(:body)
            .merge(commentable: @candidate)
      end

      def get_district
        return (params[:x].present? && params[:y].present?) == false

        location_string = KakaoLocationService.new.get_location_info(params[:x], params[:y])
        return unless location_string.present?

        #
        # 세종은 특별하다.
        # "region_1depth_name"=>"세종특별자치시", "region_2depth_name"=>"세종시", "region_3depth_name"=>"연서면 와촌리"
        # 제주도 특별하다.
        # "region_1depth_name"=>"제주특별자치도", "region_2depth_name"=>"제주시", "region_3depth_name"=>"애월읍 고성리"
        # 

        region_1depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_1depth_name')
        region_2depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_2depth_name')
        region_3depth_name = JSON.parse(location_string).dig('documents')[0]&.dig('address')&.dig('region_3depth_name')
        return unless region_1depth_name.present? || region_2depth_name.present?

        @district = District.where('name1 like ?', "#{region_3depth_name.split(' ').first}%")&.first&.voting_district
        @district = VotingDistrict.where('name1 like ?', "#{region_2depth_name}%") unless @district.present?
        @district = VotingDistrict.where('name2 like ?', "#{region_2depth_name}%") unless @district.present?
        @district = VotingDistrict.where('name1 like ?', "#{region_1depth_name}%") unless @district.present?
        @district = VotingDistrict.where('name2 like ?', "#{region_1depth_name}%") unless @district.present?

        Rails.logger.info("get_district) district: #{@district}")
      end

    end
  end
end

