class MetaFile < ApplicationRecord

  belongs_to :folder
  belongs_to :blob

  validates :name, presence: true, uniqueness: { scope: :folder_id }

  def self.create_with_name_retry(name, folder, blob)
    meta_file = self.new(name: name, folder: folder, blob: blob)

    unless meta_file.save
      meta_file.name = SecureRandom.base36(8) + "_" + meta_file.name
      meta_file.save
    end

    meta_file
  end

end
