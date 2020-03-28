class RemoveCrawlIdFromCandidates < ActiveRecord::Migration[6.0]
  def change
    remove_column :candidates, :crawl_id
  end
end
