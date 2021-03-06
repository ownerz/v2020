# == Schema Information
#
# Table name: congressmen
#
#  id                 :bigint           not null, primary key
#  code_id            :bigint
#  electoral_district :string(255)      default("")
#  party              :string(255)      default("")
#  name               :string(255)      default("")
#  sex                :string(255)      default("")
#  birth_date         :string(255)      default("")
#  address            :string(255)      default("")
#  job                :string(255)      default("")
#  education          :string(255)      default("")
#  career             :string(255)      default("")
#  voting_rate        :string(255)      default("")
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Congressman < ApplicationRecord
  belongs_to :voting_district, class_name: 'VotingDistrict', :foreign_key => :code_id
end

