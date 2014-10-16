class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :uri

      t.timestamps
    end
  end
end
