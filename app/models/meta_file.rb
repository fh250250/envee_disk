class MetaFile < ApplicationRecord

  belongs_to :folder
  belongs_to :blob

  validates :name, presence: true, uniqueness: { scope: :folder_id }

end
