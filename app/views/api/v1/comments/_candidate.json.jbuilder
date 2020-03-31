# frozen_string_literal: true

if candidate.present?
  json.id candidate.id
  # json.district_code candidate.code_id
  json.voting_district_name candidate.voting_district.name1
  json.electoral_district candidate.electoral_district
  json.candidate_type candidate.candidate_type
  json.party_number candidate.party_number
  json.party candidate.party
  json.name candidate.name
  json.photo candidate.photo
  json.sex candidate.sex
  json.birth_date candidate.birth_date
  json.wiki_page candidate.wiki_page
end
