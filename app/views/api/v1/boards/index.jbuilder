# frozen_string_literal: true

json.boards @boards, partial: 'board', as: :board
json.meta @meta
