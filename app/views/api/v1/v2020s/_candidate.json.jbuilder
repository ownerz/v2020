# frozen_string_literal: true

if candidate.present?
  json.id candidate.id
  json.district_code candidate.code_id
  json.district_name candidate.district.name
  json.electoral_district candidate.electoral_district
  json.party candidate.party
  json.name candidate.name
  json.photo candidate.photo
  json.sex candidate.sex
  json.birth_date candidate.birth_date
  json.address candidate.address
  json.job candidate.job
  json.education candidate.education
  json.career candidate.career
  json.criminal_record candidate.criminal_record
  json.reg_date candidate.reg_date
  # json.wiki_page candidate.wiki_page
end
