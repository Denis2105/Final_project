class CreateBargains < ActiveRecord::Migration[5.0]
  def change
    create_table :bargains do |t|
      t.string :title
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end
