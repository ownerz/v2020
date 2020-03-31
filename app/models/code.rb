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
#  number    :integer
#

class Code < ApplicationRecord

end
