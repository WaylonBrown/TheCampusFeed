class RemoveSecretFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :secret, :string
  end
end
