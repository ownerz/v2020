# == Schema Information
#
# Table name: codes
#
#  id        :bigint           not null, primary key
#  type      :string(255)      not null
#  name1     :string(255)      default("")
#  name2     :string(255)      default("")
#  code      :integer          not null
#  parent_id :bigint
#


class District < Code 
  belongs_to :voting_district, class_name: 'VotingDistrict', :foreign_key => :parent_id

end
