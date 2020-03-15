# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ApplicationController
      include AuditLog

      before_action :set_meta
      # before_action :set_current_user

      def index
        @boards = Board.order(board_type: :asc).order(seq: :asc).order(id: :desc)
        @boards = @boards.where(board_type: 'notice').limit(1) if params[:notice].eql?('y')
      end

      def create
        board = Board.new(board_params)
        board.save!
      rescue => e
        render_error :unprocessable_entity, e
      end

      def destroy
        board = Board.find(params[:id])
        board.destroy!
      rescue => e
        render_error :unprocessable_entity, e
      end

      private

      def board_params
        params.require(:data)
            .permit(:board_type, :title, :body, :link, :seq)
      end
    end
  end
end

