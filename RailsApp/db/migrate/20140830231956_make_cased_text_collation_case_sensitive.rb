class MakeCasedTextCollationCaseSensitive < ActiveRecord::Migration
  def up
    execute("ALTER TABLE  `tags` CHANGE  `casedText`  `casedText` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL ;")
  end
  def down
    execute("ALTER TABLE  `tags` CHANGE  `casedText`  `casedText` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL ;")
  end
end
