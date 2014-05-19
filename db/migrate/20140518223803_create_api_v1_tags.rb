class CreateApiV1Tags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :text, unique: true
      t.references :post, index: true

      t.timestamps
    end
  end
end
