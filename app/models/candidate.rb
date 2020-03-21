# == Schema Information
#
# Table name: candidates
#
#  id                 :bigint           not null, primary key
#  code_id            :bigint
#  electoral_district :string(255)      default("")
#  party              :string(255)      default("")
#  photo              :string(255)      default("")
#  name               :string(255)      default("")
#  sex                :string(255)      default("")
#  birth_date         :string(255)      default("")
#  address            :string(255)      default("")
#  job                :string(255)      default("")
#  education          :string(255)      default("")
#  career             :string(255)      default("")
#  criminal_record    :string(255)      default("")
#  reg_date           :string(255)      default("")
#  wiki_page          :string(255)      default("")
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  crawl_id           :string(255)      not null
#  candidate_no       :string(255)      default(""), not null
#

class Candidate < ApplicationRecord
  has_many :photos,
           as: :context,
           dependent: :destroy,
           inverse_of: :context

  has_many :education_photos,
           -> { where(photo_type: 'e') },
           class_name: 'Photo',
           as: :context,
           dependent: :destroy,
           inverse_of: :context

  has_many :criminal_photos,
           -> { where(photo_type: 'c') },
           class_name: 'Photo',
           as: :context,
           dependent: :destroy,
           inverse_of: :context

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :context, dependent: :destroy, inverse_of: :context
  has_many :followers, through: :likes, source: :user

  belongs_to :voting_district, class_name: 'VotingDistrict', :foreign_key => :code_id
end

