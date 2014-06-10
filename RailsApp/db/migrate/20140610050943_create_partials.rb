class CreatePartials < ActiveRecord::Migration
  def change
    create_table :partials do |t|
      t.string :name

      t.timestamps
    end
  end
end
