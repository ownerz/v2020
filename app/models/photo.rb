# == Schema Information
#
# Table name: photos
#
#  id           :bigint           not null, primary key
#  context_type :string(255)
#  context_id   :bigint
#  photo_type   :integer          not null
#  url          :string(255)      not null
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Photo < ApplicationRecord
  belongs_to :context, polymorphic: true

  # EDUCATION_RECORD_REPORT_ID = 1 # 학력
  # PROPERTY_RECORD_REPORT_ID = 2 # 재산
  # TAX_RECORD_REPORT_ID = 3 # 납세
  # MILITARY_RECORD_REPORT_ID = 4 # 병역
  # CRIMINAL_RECORD_REPORT_ID = 5 # 전과
  # ELECTION_RECORD_REPORT_ID = 8 # 공직선거 경력
  enum photo_type: [:e, :p, :t, :m, :c, :el]

end
