class CodeError < ApplicationRecord
  validates_uniqueness_of :name, :message => "The Name is already registered."

end
