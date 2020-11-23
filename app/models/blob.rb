class Blob < ApplicationRecord

  validates :sha256, presence: true, length: { is: 64 }, uniqueness: true
  validates :content_type, presence: true
  validates :size, presence: true, numericality: { only_integer: true, greater_than: 0 }

end
