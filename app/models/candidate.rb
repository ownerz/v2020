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
#

class Candidate < ApplicationRecord
  belongs_to :district, class_name: 'District', :foreign_key => :code_id
end

