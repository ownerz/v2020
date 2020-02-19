class AddCandidateNoToCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :candidates, :candidate_no, :string, null: false, default: '' # 후보자 번호
  end
end
