class Document < ApplicationRecord
    enum status: ['pending','processing','completed','cancelled','failed']
end
