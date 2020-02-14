# == Schema Information
#
# Table name: likes
#
#  id           :bigint           not null, primary key
#  context_type :string(255)
#  context_id   :bigint
#  user_id      :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Like < ApplicationRecord
  belongs_to :context,
             :polymorphic => true

  belongs_to :user

end
