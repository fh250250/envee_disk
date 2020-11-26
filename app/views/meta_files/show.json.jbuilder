if @meta_file.errors.any?

  json.errors @meta_file.errors.full_messages

else

  json.meta_file do
    json.extract! @meta_file, :name
  end

end
