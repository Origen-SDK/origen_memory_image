module MemoryImage
  class Base
    attr_reader :file

    def initialize(file, _options = {})
      @file = file
    end

    # Returns the code execution start address as an int
    def start_address
      fail "#{self.class} has not implemented the start_address method!"
    end

    # Returns the s-record as an array of addresses and data
    #
    # @param [hash] options, allows the selection of endianness swapping - ie the output will have the endianness changed
    #
    # The output is a 2D array, with each element being an array with element zero being the
    # address of the data and element one being one word of data
    # like this [[ADDR0, DATA0], [ADDR1, DATA1], [ADDR2, DATA2]...]
    #
    # The block header data and end of block value are not interpreted in any way and
    # the checksum bits are disregarded
    def to_a(options = {})
      options = {
        flip_endianness:     false,
        data_width_in_bytes: 4
      }.merge(options)
      data = extract_addr_data(options)
      if options[:flip_endianness] || options[:endianness_change]
        data.map do |v|
          [v[0], flip_endianness(v[1], 4)]
        end
      else
        data
      end
    end
    alias_method :to_array, :to_a

    # Reverse the endianness of the given data value, the width of it in bytes must
    # be supplied as the second argument
    #
    # @example
    #   flip_endianness(0x12345678, 4)  # => 0x78563412
    def flip_endianness(data, width_in_bytes)
      v = 0
      width_in_bytes.times do |i|
        # data[7:0] => data[15:8]
        start = 8 * i
        v += data[(start + 7)..start] << ((width_in_bytes - i - 1) * 8)
      end
      v
    end
  end
end
