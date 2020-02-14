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

class District < Code 
  has_many :candidates
  belongs_to :city, class_name: 'City', :foreign_key => :parent_id

end
