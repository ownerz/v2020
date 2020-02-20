# == Schema Information
#
# Table name: temp_candidates
#
#  id                 :bigint           not null, primary key
#  electoral_district :string(255)      default("")
#  party              :string(255)      default("")
#  name               :string(255)      default("")
#

class TempCandidate < ApplicationRecord
end

