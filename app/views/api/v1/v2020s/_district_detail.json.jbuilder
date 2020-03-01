# frozen_string_literal: true

if district_detail.present?
  json.id district_detail.id
  json.district_count district_detail.district_count
  json.voting_district_count district_detail.voting_district_count
  json.population district_detail.population
  json.election_population district_detail.election_population
  json.absentee district_detail.absentee
  json.voting_rate district_detail.voting_rate
  json.households district_detail.households
end
