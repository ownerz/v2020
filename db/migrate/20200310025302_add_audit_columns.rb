class AddAuditColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :user_audits, :country, :string, null: true, default: '' 
    add_column :user_audits, :region, :string, null: true, default: '' 
    add_column :user_audits, :city, :string, null: true, default: '' 
    add_column :user_audits, :postal, :string, null: true, default: '' 
    add_column :user_audits, :loc, :string, null: true, default: '' 
  end
end
