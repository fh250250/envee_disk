if @upload.errors.any?

  json.errors @upload.errors.full_messages

else

  json.upload do
    json.extract! @upload, :name, :sha256, :size, :part_size, :next_part, :part_count
    json.url part_upload_path(@upload)
  end

end
