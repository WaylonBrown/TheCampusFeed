class AddCaseInsensitiveKeyToTags < ActiveRecord::Migration
  def up
    execute("CREATE INDEX lower_tag_name ON tags(lower(text))")
  end

  def down
    execute("DROP INDEX lower_tag_name")
  end
end
