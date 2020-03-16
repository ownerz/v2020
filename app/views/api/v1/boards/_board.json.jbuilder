# frozen_string_literal: true

if board.present?
  json.id board.id
  json.board_type board.board_type
  json.title board.title
  json.body board.body
  json.link board.link
  json.seq board.seq
  json.image board.image
  json.created_at board.created_at
end