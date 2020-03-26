class AddCandidateColumns < ActiveRecord::Migration[6.0]
  def change
    # 기호
    add_column :candidates, :number, :string, null: true, default: '' 
    # 재산신고액
    add_column :candidates, :property, :string, null: true, default: '' 
    # 병역신고사
    add_column :candidates, :military, :string, null: true, default: '' 
    # 입후보회수
    add_column :candidates, :candidate_number, :string, null: true, default: '' 
    # 납부액
    add_column :candidates, :tax_payment, :string, null: true, default: '' 
    # 최근 5년간 체납액
    add_column :candidates, :latest_arrears, :string, null: true, default: '' 
    # 현 체납액
    add_column :candidates, :arrears, :string, null: true, default: '' 
  end
end
