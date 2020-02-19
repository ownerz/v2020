# == Schema Information
#
# Table name: photos
#
#  id           :bigint           not null, primary key
#  context_type :string(255)
#  context_id   :bigint
#  photo_type   :integer          not null
#  url          :string(255)      not null
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Photo < ApplicationRecord
  belongs_to :context, polymorphic: true

  enum photo_type: [:criminal, :education]

end
