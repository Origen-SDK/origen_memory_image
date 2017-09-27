module OrigenMemoryImage
  class Binary < Base
    def self.match?(file, snippet = false)
      if snippet
        file.all? { |l| l.strip =~ /^[01]*$/ }
      else
        # Replicated the relevant code from the ptools GEM to detect a binary file
        s = (File.read(file, 4096) || '')
        s = s.encode('US-ASCII', undef: :replace).split(//)
        ((s.size - s.grep(' '..'~').size) / s.size.to_f) > 0.3
      end
    end

    # Always returns 0 since binary files do not contain addresses
    def start_address
      0
    end

    def create_test_file
      data = [
        0x1EE0021C, 0x22401BE0, 0x021C2243,
        0x18E0021C, 0x5A780A43, 0x03E0034B,
        0xF7215A78, 0x0A400020, 0x22E08442,
        0x22D31FE0, 0x84421FD9, 0x1CE08442,
        0x002B20D1, 0x03E0012A, 0x01D1002B,
        0x1BD00223, 0x2340022A, 0x02D1002B,
        0x15D103E0, 0x032A01D1, 0x78000018,
        0x7C000018, 0x82000018, 0x88000018
      ]
      data = data.map { |d| d.to_s(2).rjust(32, '0') }.join
      File.open('examples/bin1.bin', 'wb') do |output|
        output.write [data].pack('B*')
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
      width = options[:data_width_in_bytes]
      address = 0

      if file
        raw = File.binread(file)
        bytes = raw.unpack('C*')
      else
        raw = lines.map(&:strip).join
        bytes = raw.scan(/.{1,8}/).map { |s| s.to_i(2) }
      end

      bytes.each_slice(width) do |d|
        v = 0
        width.times do |i|
          v |= d[i] << ((width - 1 - i) * 8) if d[i]
        end
        result << [address, v]
        address += width
      end

      result
    end
  end
end
