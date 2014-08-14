class AddCaseInsensitiveKeyToTags < ActiveRecord::Migration
  #this migration doesn't work on mysql, switching to mysql means I have to disable it.
  def up
    #execute("CREATE INDEX lower_tag_name ON tags(lower(text))")
  end

  def down
    #execute("DROP INDEX lower_tag_name")
  end
end
