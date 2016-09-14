class AddBargainUrlToBargains < ActiveRecord::Migration[5.0]
  def change
    add_column :bargains, :bargain_url, :text
  end
end
