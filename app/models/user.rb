# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  device_id  :string(255)
#  age        :integer          default(0)
#  sex        :integer          default("nothing")
#  latitude   :float(24)        default(0.0), not null
#  longitude  :float(24)        default(0.0), not null
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord

  enum sex: [:nothing, :man, :woman]

  # user likes someone
  has_many :likes, dependent: :destroy
  has_many :liked_candidates, through: :likes, source: :context, source_type: 'Candidate'

end

