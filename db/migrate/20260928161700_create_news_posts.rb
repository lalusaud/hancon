class CreateNewsPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :news_posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :excerpt
      t.text :body, null: false
      t.boolean :published, default: false, null: false
      t.datetime :published_at

      t.timestamps
    end
    add_index :news_posts, :slug, unique: true
    add_index :news_posts, [:published, :published_at]
  end
end
