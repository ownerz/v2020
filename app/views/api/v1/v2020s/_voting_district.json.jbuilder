# frozen_string_literal: true

if voting_district.present?
  json.id voting_district.id
  json.city_name voting_district.city.name1
  json.voting_district_name voting_district.name1
  json.district_name voting_district.name2
  # json.code voting_district.code

  # 당선된 국회의원
  json.congressman voting_district.congressman, partial: 'congressman', as: :congressman
  # 선거 지역 상세
  json.district_detail voting_district.district_detail, partial: 'district_detail', as: :district_detail

  # 후보자
  # json.candidates voting_district.candidates, partial: 'candidate', as: :candidate
  unless defined?(only_district)
    json.candidates voting_district.candidates, partial: '/api/v1/candidates/candidate', as: :candidate
  end
end
