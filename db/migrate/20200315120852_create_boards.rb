class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.integer :board_type, null: true
      t.string :title, null: false
      t.text :body, null: true
      t.string :link, null: true, limit: 1000
      t.integer :seq, null: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
