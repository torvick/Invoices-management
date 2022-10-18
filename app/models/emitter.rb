class Emitter < ApplicationRecord
  has_many :invoices
  validates :name, presence: true
  validates :rfc, presence: true , uniqueness: true

  enum status: { inactive: false, active: true }
end
