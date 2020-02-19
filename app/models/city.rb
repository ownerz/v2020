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

class City < Code 
  has_many :voting_districts, foreign_key: :parent_id, dependent: :destroy
  belongs_to :election, class_name: 'Election', :foreign_key => :parent_id

end
