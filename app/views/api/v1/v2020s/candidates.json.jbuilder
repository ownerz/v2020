# frozen_string_literal: true

json.candidates @candidates, partial: 'candidate', as: :candidate
json.meta @meta
