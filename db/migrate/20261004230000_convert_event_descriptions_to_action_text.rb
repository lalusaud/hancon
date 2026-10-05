class ConvertEventDescriptionsToActionText < ActiveRecord::Migration[8.1]
  def up
    select_all("SELECT id, description FROM events WHERE description IS NOT NULL").each do |row|
      ActionText::RichText.create!(
        record_type: "Event",
        record_id: row.fetch("id"),
        name: "description",
        body: row.fetch("description")
      )
    end

    remove_column :events, :description, :text
  end

  def down
    add_column :events, :description, :text

    select_all("SELECT record_id, body FROM action_text_rich_texts WHERE record_type = 'Event' AND name = 'description'").each do |row|
      execute <<~SQL
        UPDATE events
        SET description = #{connection.quote(row.fetch("body"))}
        WHERE id = #{connection.quote(row.fetch("record_id"))}
      SQL
    end
  end
end
