class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.belongs_to :votable, index: true

      t.timestamps
    end
  end
end
