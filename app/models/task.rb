class Task < ApplicationRecord
  validates :name, :description, :presence => true
  validates :name, :length => { maximum: 15 }
end
