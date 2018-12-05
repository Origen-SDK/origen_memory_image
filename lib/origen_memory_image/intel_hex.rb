module OrigenMemoryImage
  class IntelHex < Base
    def self.match?(snippet)
      snippet.all? do |line|
        line.empty? || line =~ /^:[0-9A-Fa-f]{6}0[0-5]/
      end
    end

    def start_address
      @start_address ||= begin
        addrs = []
        lines.each do |line|
          if start_linear_address?(line)
            addrs << decode(line)[:data].to_i(16)
          end
        end
        addrs.last || 0
      end
    end

    private

    def decode(line)
      d = {}
      line =~ /^:([0-9A-Fa-f]{2})([0-9A-Fa-f]{4})(\d\d)([0-9A-Fa-f]+)([0-9A-Fa-f]{2})$/
      d[:byte_count] = Regexp.last_match(1).to_i(16)
      d[:address] = Regexp.last_match(2).to_i(16)
      d[:record_type] = Regexp.last_match(3).to_i(16)
      d[:data] = Regexp.last_match(4)
      d[:checksum] = Regexp.last_match(5).to_i(16)
      d
    end

    def data?(line)
      !!(line =~ /^:[0-9A-Fa-f]{6}00/)
    end

    def extended_segment_address?(line)
      !!(line =~ /^:[0-9A-Fa-f]{6}02/)
    end

    def extended_linear_address?(line)
      !!(line =~ /^:[0-9A-Fa-f]{6}04/)
    end

    def start_linear_address?(line)
      !!(line =~ /^:[0-9A-Fa-f]{6}05/)
    end

    def upper_addr
      @upper_addr || 0
    end

    def segment_address
      @segment_address || 0
    end

    # Returns an array containing all address/data from the given s-record
    # No address manipulation is performed, that is left to the caller to apply
    # any scrambling as required by the target system
    def extract_addr_data(options = {})
      options = {
        data_width_in_bytes: 4
      }.merge(options)

      result = []
      lines.each do |line|
        if extended_segment_address?(line)
          @segment_address = decode(line)[:data].to_i(16) * 16

        elsif extended_linear_address?(line)
          @upper_addr = (decode(line)[:data].to_i(16)) << 16

        elsif data?(line)
          d = decode(line)
          addr = d[:address] + segment_address + upper_addr

          data = d[:data]
          data_matcher = '\w\w' * options[:data_width_in_bytes]
          data.scan(/#{data_matcher}/).each do |data_packet|
            result << [addr, data_packet.to_i(16)]
            addr += options[:data_width_in_bytes]
          end
          # If a partial word is left over
          if (remainder = data.length % (2 * options[:data_width_in_bytes])) > 0
            result << [addr, data[data.length - remainder..data.length].to_i(16)]
          end
        end
      end
      result
    end
  end
end
