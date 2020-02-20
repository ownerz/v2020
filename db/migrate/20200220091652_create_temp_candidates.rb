class CreateTempCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :temp_candidates do |t|
      t.string :electoral_district, default: '', comment: '선거구명'
      t.string :party, default: '', comment: '소속정당명'
      t.string :name, default: '', comment: '성명'
    end
  end
end
