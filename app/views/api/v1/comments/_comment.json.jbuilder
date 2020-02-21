# frozen_string_literal: true

if comment.present?
  json.body comment.body
  json.user_id comment.user_id
  json.candidate comment.commentable, partial: 'candidate', as: :candidate
end
