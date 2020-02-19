# frozen_string_literal: true

json.cities @cities, partial: 'city', as: :city
json.meta @meta
