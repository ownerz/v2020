# == Schema Information
#
# Table name: codes
#
#  id        :bigint           not null, primary key
#  type      :string(255)      not null
#  name      :string(255)      default("")
#  code      :integer          not null
#  parent_id :bigint
#

class Election < Code 
  has_many :cities, foreign_key: :parent_id, dependent: :destroy
end
