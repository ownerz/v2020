module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_comment, only: %i[destroy update]
      before_action :set_current_user

      def update
        if @comment.update(comment_params)
          render_response resource: {}, meta: default_meta
        else
          render_error :unprocessable_entity, @comment.errors
        end
      rescue
        render_error :unprocessable_entity, e
      end

      def destroy
        if @comment.destroy
          render_response resource: {}, meta: default_meta
        else
          render_error :unprocessable_entity, @comment.errors
        end
      rescue
        render_error :unprocessable_entity, e
      end

      def index
        @comments = Comment.where(user: @current_user)
        @comments = @comments.page(params[:page]).per(params[:per_page])
      rescue
        render_error :unprocessable_entity, e
      end

      private

      def set_current_user
        @current_user = User.find_by!(device_id: request.headers['device-id'])
      rescue
        render_error :unprocessable_entity, 'current_user not found'
      end

      def set_comment
        @comment = Comment.find(params[:id])
      rescue
        render_error :unprocessable_entity, 'comment not found'
      end

      def comment_params
        params.require(:data)
            .permit(:body)
      end
    end
  end
end
