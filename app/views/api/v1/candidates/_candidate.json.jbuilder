# frozen_string_literal: true

if candidate.present?
  json.id candidate.id
  # json.district_code candidate.code_id
  json.voting_district_name candidate.voting_district.name1
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

  json.criminal_photos candidate.criminal_photos, partial: '/api/v1/candidates/photo', as: :photo
  json.education_photos candidate.education_photos, partial: '/api/v1/candidates/photo', as: :photo

  # json.criminal_photos candidate.criminal_photos
  # json.education_photos candidate.education_photos
  json.reg_date candidate.reg_date
  json.wiki_page candidate.wiki_page

  # 내가 좋아요 한 후보인지.
  # json.liked @current_user.liked_candidates.include?(candidate)
  
  json.liked @liked_candidates.present?? @liked_candidates.include?(candidate.id) : false

end
