class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string   :device_id, null: false, index: true
      t.integer  :age, default: 0
      t.integer  :sex, default: 0

      t.float :latitude, null: false, default: 0
      t.float :longitude, null: false, default: 0

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
