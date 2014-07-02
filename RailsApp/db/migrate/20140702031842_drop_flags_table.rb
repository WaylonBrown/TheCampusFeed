class DropFlagsTable < ActiveRecord::Migration
  def change
    drop_table :flags
  end
end
