class CreateCongressmen < ActiveRecord::Migration[6.0]
  def change
    create_table :congressmen do |t|
      t.references :code, foreign_key: true
      t.string :electoral_district, default: '', comment: '선거구명'
      t.string :party, default: '', comment: '소속정당명'
      t.string :name, default: '', comment: '성명'
      t.string :sex, default: '', comment: '성별'
      t.string :birth_date, default: '', comment: '생년월일(연령)'
      t.string :address, default: '', comment: '주소'
      t.string :job, default: '', comment: '직업'
      t.string :education, default: '', comment: '학력'
      t.string :career, default: '', comment: '경력'
      t.string :voting_rate, default: '', comment: '득표수(득표율)'

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
