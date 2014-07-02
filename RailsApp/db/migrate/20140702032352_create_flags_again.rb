class CreateFlagsAgain < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :flaggable_id
      t.string :flaggable_type

      t.timestamps
    end
  end
end
