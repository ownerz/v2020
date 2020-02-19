# frozen_string_literal: true

if voting_district.present?
  json.id voting_district.id
  json.city_name voting_district.city.name1
  json.voting_district_name voting_district.name1
  json.district_name voting_district.name2
  json.code voting_district.code
end
