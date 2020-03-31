class AddCandidateTypeToCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :candidates, :candidate_type, :integer
    add_column :candidates, :party_number, :integer, default: 0
  end
end
