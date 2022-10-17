class AddNameAndRfcToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, default: ""
    add_column :users, :rfc, :string, default: ""
  end
end
