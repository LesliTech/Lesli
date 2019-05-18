class CreateWebsiteLandings < ActiveRecord::Migration[5.2]
  def change
    create_table :website_landings do |t|

      t.timestamps
    end
  end
end
