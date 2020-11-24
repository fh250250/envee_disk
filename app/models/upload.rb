class Upload < ApplicationRecord

  belongs_to :folder

  validates :name, presence: true
  validates :sha256, presence: true, length: { is: 64 }, uniqueness: { scope: :folder_id }
  validates :size, :part_size, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def part_count
    size.fdiv(part_size).ceil
  end

  def is_completed?
    next_part >= part_count
  end

end
