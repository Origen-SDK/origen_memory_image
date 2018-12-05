require 'origen'
require_relative '../config/application.rb'

module OrigenMemoryImage
  autoload :Base, 'origen_memory_image/base'
  autoload :SRecord, 'origen_memory_image/s_record'
  autoload :Hex, 'origen_memory_image/hex'
  autoload :Binary, 'origen_memory_image/binary'
  autoload :IntelHex, 'origen_memory_image/intel_hex'

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
    # Always do the binary first since the others won't be able to process
    # a binary snippet
    when options[:type] == :binary || (options[:source] != String && Binary.match?(file))
      Binary
    when options[:source] == String && Binary.match?(snippet, true)
      Binary
    when options[:type] == :srecord || SRecord.match?(snippet)
      SRecord
    when options[:type] == :intel_hex || IntelHex.match?(snippet)
      IntelHex
    when options[:type] == :hex || Hex.match?(snippet)
      Hex
    else
      fail "Unknown format for image file: #{file}"
    end
  end
end
