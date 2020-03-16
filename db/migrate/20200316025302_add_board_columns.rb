class AddBoardColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :image, :string, null: true, limit: 1000
  end
end
