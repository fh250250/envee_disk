class Upload < ApplicationRecord

  belongs_to :folder

  validates :name, presence: true
  validates :sha256, presence: true, length: { is: 64 }, uniqueness: { scope: :folder_id }
  validates :size, :part_size, presence: true, numericality: { only_integer: true, greater_than: 0 }

  after_destroy :clean_parts

  def part_count
    size.fdiv(part_size).ceil
  end

  def is_completed?
    next_part >= part_count
  end

  def dirname
    File.join Rails.configuration.disk[:parts_path], id.to_s
  end

  def save_part_from(src_part)
    dest_part = File.join dirname, next_part.to_s

    begin
      transaction do
        increment! :next_part, 1, touch: true
        FileUtils.mkdir_p dirname
        FileUtils.mv src_part, dest_part
      end
      true
    rescue
      false
    end
  end

  def merge_parts_to_blob
    tmpfile = dirname + ".tmp"

    begin
      mime = nil

      File.open(tmpfile, "wb") do |out|
        Dir.children(dirname)
        .sort { |a, b| a.to_i - b.to_i }
        .each do |part_name|
          part_file = File.join(dirname, part_name)

          File.open(part_file, "rb") do |part|
            while buf = part.read(8 * 1024)
              out << buf
            end
          end

          File.delete part_file
        end
      end

      Dir.rmdir dirname

      File.open(tmpfile) do |f|
        mime = MimeMagic.by_magic f
      end

      blob = Blob.new sha256: Digest::SHA256.file(tmpfile).hexdigest,
                    size: size,
                    mime: mime

      if blob.save
        FileUtils.mkdir_p Rails.configuration.disk[:blobs_path]
        FileUtils.mv tmpfile, File.join(Rails.configuration.disk[:blobs_path], blob.sha256)
        blob
      else
        FileUtils.rm tmpfile
        Blob.find_by sha256: blob.sha256
      end
    rescue
      nil
    end
  end

  private

  def clean_parts
    FileUtils.rm_rf dirname
  end

end
