class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_uuid
      t.integer :status
      t.integer :amount
      t.string :currency
      t.date :emitted_at
      t.date :expires_at
      t.date :signed_at
      t.string :cfdi_digital_stamp
      t.belongs_to :user
      t.belongs_to :emitter

      t.timestamps
    end
  end
end
