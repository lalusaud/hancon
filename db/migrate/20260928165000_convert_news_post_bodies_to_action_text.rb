class ConvertNewsPostBodiesToActionText < ActiveRecord::Migration[8.1]
  def up
    select_all("SELECT id, body FROM news_posts WHERE body IS NOT NULL").each do |row|
      ActionText::RichText.create!(
        record_type: "NewsPost",
        record_id: row.fetch("id"),
        name: "body",
        body: row.fetch("body")
      )
    end

    remove_column :news_posts, :body, :text
  end

  def down
    add_column :news_posts, :body, :text

    select_all("SELECT record_id, body FROM action_text_rich_texts WHERE record_type = 'NewsPost' AND name = 'body'").each do |row|
      execute <<~SQL
        UPDATE news_posts
        SET body = #{connection.quote(row.fetch("body"))}
        WHERE id = #{connection.quote(row.fetch("record_id"))}
      SQL
    end
  end
end
