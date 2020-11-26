class Blob < ApplicationRecord

  validates :sha256, presence: true, length: { is: 64 }, uniqueness: true
  validates :size, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def path
    File.join Rails.configuration.disk[:blobs_path], sha256
  end

  def is_image?
    mime.start_with? "image"
  end

  def is_video?
    mime.start_with? "video"
  end

  def is_audio?
    mime.start_with? "audio"
  end

  def can_preview?
    is_image? or is_audio? or is_video?
  end

end
