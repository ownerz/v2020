class CreateDistrictDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :district_details do |t|
      t.references :code, foreign_key: true

      t.integer :district_count, null: false, comment: '읍면동수'
      t.integer :voting_district_count, null: false, comment: '투표구수'
      t.integer :population, null: false, comment: '인구수'
      t.integer :election_population, null: false, comment: '선거인수'
      t.integer :absentee, null: false, comment: '거소투표(부재자) 신고인명부 등재자수'
      t.decimal :voting_rate, null: false, :precision => 5, :scale => 2, comment: '인구대비 선거인 비율(%)' 
      t.integer :households, null: false, comment: '새대수' 

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
