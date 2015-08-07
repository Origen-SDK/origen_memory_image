require 'origen'
require_relative '../config/application.rb'
require_relative '../config/environment.rb'

module OrigenMemoryImage
  def self.new(file, options = {})
    unless options[:source] == String
      file = Origen.file_handler.clean_path_to(file)
    end
    find_type(file, options).new(file, options)
  end

  # Returns the class of the image manager for the given file
  def self.find_type(file, options = {})
    # Read first 10 lines
    if options[:source] == String
      snippet = file.split("\n")
    else
      snippet = File.foreach(file.to_s).first(1)
    end
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
