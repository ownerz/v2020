# frozen_string_literal: true

module Api
  module V1
    class V2020sController < ApplicationController
      before_action :set_meta

      # candidate list
      def candidates
        candidate = Candidate.last
        @candidates = Candidate.where(crawl_id: candidate&.crawl_id)
        @candidates = @candidates.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@candidates).merge(meta_status)
      end

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

    end
  end
end

