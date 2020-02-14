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

class Code < ApplicationRecord

end
