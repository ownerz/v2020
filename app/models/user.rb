# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  device_id  :string(255)      not null
#  age        :integer          default("twenteen")
#  sex        :integer          default("woman")
#  latitude   :float(24)        default(0.0), not null
#  longitude  :float(24)        default(0.0), not null
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  validates :device_id, uniqueness: true

  enum age: [:twenteen , :thirty, :fourty, :fifty, :sixty]
  enum sex: [:woman, :man, :none]

  # user likes someone
  has_many :likes, dependent: :destroy
  has_many :liked_candidates, through: :likes, source: :context, source_type: 'Candidate'

  # comments
  has_many :comments, dependent: :destroy
  has_many :my_comments, as: :commentable, class_name: "Comment"

  def add_comment_to(commentable_obj)
    comments.where(context: commentable_obj).first_or_create
  end

  def add_like_to(likeable_obj)
    new_record = false
    likes.where(context: likeable_obj).first_or_create do
      new_record = true
    end
    remove_like_from(likeable_obj) if new_record == false
  end

  private 

  def remove_like_from(likeable_obj)
    likes.where(context: likeable_obj).destroy_all
  end

end

