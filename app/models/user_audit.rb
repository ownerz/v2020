# == Schema Information
#
# Table name: user_audits
#
#  id          :bigint           not null, primary key
#  device_id   :string(255)      not null
#  request_url :string(255)      not null
#  geo_info    :text(65535)
#  remote_ip   :string(24)       default("")
#  platform    :string(32)       default("")
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UserAudit < ApplicationRecord
  acts_as_paranoid

  # belongs_to :user
end
