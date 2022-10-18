class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :jwt_authenticatable, :registerable, jwt_revocation_strategy: JwtDenylist
  has_many :invoices
  validates :email, :uniqueness => {:allow_blank => true}
  validates :name, presence: true
  validates :rfc, presence: true , uniqueness: true
  enum status: ['inactive','active']
end
