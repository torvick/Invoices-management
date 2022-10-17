class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :name
      t.jsonb  :successful
      t.jsonb  :failed
      t.integer :status

      t.timestamps
    end
  end
end
