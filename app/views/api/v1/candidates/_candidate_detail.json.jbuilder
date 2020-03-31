# frozen_string_literal: true

if candidate.present?
  json.id candidate.id
  # json.district_code candidate.code_id
  json.voting_district_name candidate.voting_district&.name1.present?? candidate.voting_district.name1 : ''
  json.electoral_district candidate.electoral_district
  json.party candidate.party
  json.candidate_type candidate.candidate_type
  json.party_number candidate.party_number
  json.name candidate.name
  json.photo candidate.photo
  json.sex candidate.sex
  json.birth_date candidate.birth_date
  json.address candidate.address
  json.job candidate.job
  json.education candidate.education
  json.career candidate.career
  json.criminal_record candidate.criminal_record

  json.education_photos candidate.education_photos, partial: '/api/v1/candidates/photo', as: :photo
  json.property_photos candidate.property_photos, partial: '/api/v1/candidates/photo', as: :photo
  json.tax_photos candidate.tax_photos, partial: '/api/v1/candidates/photo', as: :photo
  json.military_photos candidate.military_photos, partial: '/api/v1/candidates/photo', as: :photo
  json.criminal_photos candidate.criminal_photos, partial: '/api/v1/candidates/photo', as: :photo
  json.election_photos candidate.election_photos, partial: '/api/v1/candidates/photo', as: :photo

  # json.criminal_photos candidate.criminal_photos
  # json.education_photos candidate.education_photos
  json.reg_date candidate.reg_date
  json.wiki_page candidate.wiki_page

  json.number candidate.number
  json.property candidate.property
  json.military candidate.military
  json.candidate_number candidate.candidate_number
  json.tax_payment candidate.tax_payment
  json.latest_arrears candidate.latest_arrears
  json.arrears candidate.arrears

  # # 후보자를 bookmark 한 user 수
  # json.followers candidate.followers.size

  # # 내가 좋아요 한 후보인지.
  # json.liked @liked_candidates.present?? @liked_candidates.include?(candidate.id) : false
end
