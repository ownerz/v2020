# == Schema Information
#
# Table name: boards
#
#  id         :bigint           not null, primary key
#  board_type :integer
#  title      :string(255)      not null
#  body       :text(65535)
#  link       :string(1000)
#  seq        :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(1000)
#

class Board < ApplicationRecord
  acts_as_paranoid

  enum board_type: [:notice, :normal, :head]
end
