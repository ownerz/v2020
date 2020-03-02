class CreateUserAudits < ActiveRecord::Migration[6.0]
  def change
    create_table :user_audits do |t|
      t.string :device_id, null: false, index: true
      t.string :request_url, null: false
      t.text :geo_info
      t.string :remote_ip, default: '', limit: 24
      t.string :platform, default: '', limit: 32
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
