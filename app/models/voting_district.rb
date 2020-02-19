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


class VotingDistrict < Code 
  has_many :candidates
  has_many :districts, foreign_key: :parent_id
  belongs_to :city, class_name: 'City', :foreign_key => :parent_id
end
