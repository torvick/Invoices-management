class CreateEmitters < ActiveRecord::Migration[6.1]
  def change
    create_table :emitters do |t|
      t.string :name, null: false, default: ""
      t.string :rfc, null: false, default: ""
      t.boolean :status, default: 1

      t.timestamps
    end
  end
end
