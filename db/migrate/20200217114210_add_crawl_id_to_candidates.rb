class AddCrawlIdToCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :candidates, :crawl_id, :string, null: false
    add_index :candidates, :crawl_id
  end
end
