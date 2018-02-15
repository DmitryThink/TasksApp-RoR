class List < ApplicationRecord
  validates :name, :presence => true
  validates :name, :length => { maximum: 15 }
  validates :name, :uniqueness => true
end
