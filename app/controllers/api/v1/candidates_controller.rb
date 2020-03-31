# frozen_string_literal: true

module Api
  module V1
    class CandidatesController < ApplicationController
      include AuditLog

      before_action :set_meta
      before_action :set_district, only: [:index]
      before_action :set_current_user, only: %i[show_comments create_comments index show]
      before_action :set_candidate, only: %i[show_comments create_comments show]

      # candidate list
      def index
        if params[:party_number].present? && params[:party_number].to_i > 0 # 비례후보
          @candidates = Candidate.where(candidate_type: :proportional) 
          @candidates = @candidates.where(party_number: params[:party_number]) 
          @candidates = @candidates.order('number*1 asc')
        else # 정식후보
          @liked_candidates = @current_user.liked_candidates.pluck('id')
          @candidates = @district.present?? Candidate.where(voting_district: @district) : Candidate.all
          @candidates = @candidates.order('number*1 asc')
        end
        @candidates = @candidates.page(params[:page]).per(params[:per_page])
        @meta = get_page_info(@candidates).merge(meta_status)
      end

      def show
        @liked_candidates = @current_user.liked_candidates.pluck('id')
      end

      def create_comments
        @current_user.comments.create(comment_params)
        render_response resource: {}, meta: default_meta
      end

      def show_comments
        @comments = @candidate.comments
      end

      def order_by_followers
        Candidate.left_joins(:followers)
                  .select("candidates.id, candidates.electoral_district, candidates.party, candidates.name, count(likes.id) as follower_count")
                  .group(:id)
                  .order('follower_count DESC')
                  .limit(10)
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

    end
  end
end

