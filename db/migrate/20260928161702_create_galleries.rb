class CreateGalleries < ActiveRecord::Migration[8.1]
  def change
    create_table :galleries do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :published, default: false, null: false

      t.timestamps
    end
    add_index :galleries, [:published, :created_at]
  end
end
