# frozen_string_literal: true

if @current_user.present?
  json.candidates @current_user.liked_candidates, partial: '/api/v1/candidates/candidate', as: :candidate
end
json.meta @meta