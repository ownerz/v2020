# frozen_string_literal: true
if @only_district.eql?('y')
  json.voting_districts @voting_district, partial: 'voting_district', locals: { only_district: true }, as: :voting_district
else
  json.voting_districts @voting_district, partial: 'voting_district', as: :voting_district
end
json.meta @meta