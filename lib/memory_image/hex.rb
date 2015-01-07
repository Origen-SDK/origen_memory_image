module MemoryImage
  class Hex < Base
    def self.match?(snippet)
      snippet.any? do |line|
        # Match a line like:
        # @180000F0
        line =~ /^@[0-9a-fA-F]+\s?$/
      end
    end

    # The first in the file will be taken as the start address
    def start_address
      @start_address ||= begin
        File.readlines(file).each do |line|
          if line =~ /^@([0-9a-fA-F]+)\s?$/
            return Regexp.last_match[1].to_i(16)
          end
        end
      end
    end

    private

    # Returns an array containing all address/data from the given s-record
    # No address manipulation is performed, that is left to the caller to apply
    # any scrambling as required by the target system
    def extract_addr_data(options = {})
      options = {
        data_width_in_bytes: 4
      }.merge(options)

      result = []
      File.readlines(file).each do |line|
        # Only if the line is an s-record with data...
        if line =~ /^@([0-9a-fA-F]+)\s?$/
          @address = Regexp.last_match[1].to_i(16)
        elsif line =~ /^[0-9A-F]/
          unless @address
            fail "Hex data found before an @address line in #{file}"
          end
          data = line.strip.gsub(/\s/, '')
          data_matcher = '\w\w' * options[:data_width_in_bytes]
          data.scan(/#{data_matcher}/).each do |data_packet|
            result << [@address, data_packet.to_i(16)]
            @address += options[:data_width_in_bytes]
          end
          # If a partial word is left over
          if (remainder = data.length % (2 * options[:data_width_in_bytes])) > 0
            result << [@address, data[data.length - remainder..data.length].to_i(16)]
          end
        end
      end
      result
    end
  end
end
