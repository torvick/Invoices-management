class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :emitter

  validates :invoice_uuid, presence: true , uniqueness: true
  validates :status, presence: true
  validates :amount, presence: true
  validates :emitted_at, presence: true
  validates :expires_at, presence: true
  validates :signed_at, presence: true
  validates :cfdi_digital_stamp, presence: true

  enum status: { inactive: 0, active: 1 }

  scope :filter_by_status, -> (status) { where status: status }
  scope :filter_by_emitter, -> (emitter_id) { where emitter_id: emitter_id }
  scope :filter_by_receiver, -> (user_id) { where user_id: user_id }
  scope :filter_by_amount_range, -> (lower, greater) { where(amount: lower..greater)}
  scope :filter_by_emitted_at, -> (emitted_at) { where emitted_at: emitted_at }

end
