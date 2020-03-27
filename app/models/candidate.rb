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
#  number             :string(255)      default("")
#  property           :string(255)      default("")
#  military           :string(255)      default("")
#  candidate_number   :string(255)      default("")
#  tax_payment        :string(255)      default("")
#  latest_arrears     :string(255)      default("")
#  arrears            :string(255)      default("")
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

  has_many :property_photos,
           -> { where(photo_type: 'p') },
           class_name: 'Photo',
           as: :context,
           dependent: :destroy,
           inverse_of: :context

  has_many :tax_photos,
           -> { where(photo_type: 't') },
           class_name: 'Photo',
           as: :context,
           dependent: :destroy,
           inverse_of: :context

  has_many :military_photos,
           -> { where(photo_type: 'm') },
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

  has_many :election_photos,
           -> { where(photo_type: 'el') },
           class_name: 'Photo',
           as: :context,
           dependent: :destroy,
           inverse_of: :context

  has_many :comments, as: :commentable, dependent: :destroy

  has_many :likes, as: :context, dependent: :destroy, inverse_of: :context
  has_many :followers, through: :likes, source: :user

  belongs_to :voting_district, class_name: 'VotingDistrict', :foreign_key => :code_id
end

