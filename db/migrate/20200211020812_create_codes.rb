class CreateCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :codes do |t|
      t.string  'type',       null: false
      t.string :name1, default: '', comment: '이름'
      t.string :name2, default: '', comment: '이름'
      t.integer :code, null: false, comment: '코드'

      t.bigint :parent_id
    end
  end
end
