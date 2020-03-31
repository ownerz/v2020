class AddNumberToCodes < ActiveRecord::Migration[6.0]
  def change
    add_column :codes, :number, :integer # 정당 기호 => Party 에서 사용.
  end
end
