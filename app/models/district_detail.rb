# == Schema Information
#
# Table name: district_details
#
#  id                    :bigint           not null, primary key
#  code_id               :bigint
#  district_count        :integer          not null
#  voting_district_count :integer          not null
#  population            :integer          not null
#  election_population   :integer          not null
#  absentee              :integer          not null
#  voting_rate           :decimal(5, 2)    not null
#  households            :integer          not null
#  deleted_at            :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#


class DistrictDetail < ApplicationRecord
  belongs_to :voting_district, class_name: 'VotingDistrict', :foreign_key => :code_id
end

