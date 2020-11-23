class Upload < ApplicationRecord

  belongs_to :folder

  validates :name, presence: true
  validates :sha256, presence: true, length: { is: 64 }, uniqueness: { scope: :folder_id }
  validates :content_type, presence: true
  validates :size, :part_size, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :cursor, numericality: { only_integer: true, greater_than: 0 }

end
