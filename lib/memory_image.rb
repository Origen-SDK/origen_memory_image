module MemoryImage
  def self.new(file, options = {})
    file ||= RGen.file_handler.clean_path_to(file)
    find_type(file).new(file, options)
  end

  # Returns the class of the image manager for the given file
  def self.find_type(file, options = {})
    # Read first 10 lines
    snippet = File.foreach(file.to_s).first(1)
    case
    when options[:type] == :srecord || SRecord.match?(snippet)
      SRecord
    when options[:type] == :hex || Hex.match?(snippet)
      Hex
    else
      fail "Unknown format for image file: #{file}"
    end
  end
end
