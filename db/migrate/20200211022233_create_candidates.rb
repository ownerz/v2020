class CreateCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :candidates do |t|
      t.references :code, foreign_key: true
      t.string :electoral_district, default: '', comment: '선거구명'
      t.string :party, default: '', comment: '소속정당명'
      t.string :photo, default: '', comment: '사진'
      t.string :name, default: '', comment: '성명'
      t.string :sex, default: '', comment: '성별'
      t.string :birth_date, default: '', comment: '생년월일(연령)'
      t.string :address, default: '', comment: '주소'
      t.string :job, default: '', comment: '직업'
      t.string :education, default: '', comment: '학력'
      t.string :career, default: '', comment: '경력'
      t.string :criminal_record, default: '', comment: '전과기록'
      t.string :reg_date, default: '', comment: '등록일자'
      t.string :wiki_page, default: '', comment: '나무위키 page'
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
