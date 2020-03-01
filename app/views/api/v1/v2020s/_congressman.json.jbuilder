# frozen_string_literal: true
if congressman.present?
  json.id congressman.id
  json.party congressman.party
  json.name congressman.name
  json.sex congressman.sex
  json.birth_date congressman.birth_date
  json.address congressman.address
  json.job congressman.job
  json.education congressman.education
  json.career congressman.career
  json.voting_rate congressman.voting_rate
end
