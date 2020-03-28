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
  has_one :district_detail, :foreign_key => :code_id
  has_one :congressman, :foreign_key => :code_id
  # has_many :candidates, -> {order(number: :asc)}, :foreign_key => :code_id
  has_many :candidates, -> {order('number+0 asc')}, :foreign_key => :code_id
  has_many :districts, foreign_key: :parent_id
  belongs_to :city, class_name: 'City', :foreign_key => :parent_id

  scope :search_by_keyword, ->(keyword) {
    VotingDistrict.left_outer_joins(:districts).left_outer_joins(:candidates).where("codes.name1 like :keyword or districts_codes.name1 like :keyword or candidates.name like :keyword", keyword: "%#{keyword}%").distinct
  }
end
