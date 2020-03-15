# frozen_string_literal: true
if @option.eql?('only_district')
  json.voting_districts @voting_districts, partial: 'voting_district', as: :voting_district, locals: { only_district: true }
else
  json.voting_districts @voting_districts, partial: 'voting_district', as: :voting_district
end
json.meta @meta
