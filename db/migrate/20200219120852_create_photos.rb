class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.references :context, polymorphic: true
      t.integer :photo_type, null: false
      t.string :url, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
