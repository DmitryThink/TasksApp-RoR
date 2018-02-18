class List < ApplicationRecord
  validates :name, :presence => true
  validates :name, :length => { maximum: 15 }
end
