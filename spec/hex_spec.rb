require 'spec_helper'

describe "Hex" do

  before :all do
    @hex = OrigenMemoryImage.new("examples/hex1.hex")
  end

  it "code_start_address method works" do
    @hex.start_address.should == 0x18000000
  end

  it "to_a method works" do
    @hex.to_a.should == [
      [0x18000000, 0x1EE0021C], [0x18000004, 0x22401BE0], [0x18000008, 0x021C2243],
      [0x1800000C, 0x18E0021C], [0x18000010, 0x5A780A43], [0x18000014, 0x03E0034B],
      [0x18000018, 0xF7215A78], [0x1800001C, 0x0A400020], [0x18000020, 0x22E08442],
      [0x18000024, 0x22D31FE0], [0x18000028, 0x84421FD9], [0x1800002C, 0x1CE08442],
      [0x180000E0, 0x002B20D1], [0x180000E4, 0x03E0012A], [0x180000E8, 0x01D1002B],
      [0x180000EC, 0x1BD00223], [0x180000F0, 0x2340022A], [0x180000F4, 0x02D1002B],
      [0x180000F8, 0x15D103E0], [0x180000FC, 0x032A01D1], [0x180001F0, 0x78000018],
      [0x180001F4, 0x7C000018], [0x180001F8, 0x82000018], [0x180001FC, 0x88000018],
    ]
  end

  it "data_width_in_bytes option works" do
    data = @hex.to_a(data_width_in_bytes: 2)
    data[0].should == [0x18000000, 0x1EE0]
    data[1].should == [0x18000002, 0x021C]
    data.size.should == 48
  end

  it "endianness_change option works" do
    data = @hex.to_a(flip_endianness: true)
    data[0].should == [0x18000000, 0x1C02E01E]
    data[1].should == [0x18000004, 0xE01B4022]
    data.size.should == 24
  end

  it "creating from a string works" do
    str = <<-END
@2D100E00
0D 15 0F 13 0E 14 10 12
00 00 04 17 04 03 05 06
    END
    @hex = OrigenMemoryImage.new(str, source: String)
    @hex.start_address.should == 0x2D100E00
    @hex.to_a.should == [
      [0x2D100E00, 0x0D150F13], [0x2D100E04, 0x0E141012],
      [0x2D100E08, 0x00000417], [0x2D100E0C, 0x04030506],
    ]
  end
  
  it "crop option works" do
    @hex.to_a(crop: [0x18000024]).should == [
      [0x18000024, 0x22D31FE0], [0x18000028, 0x84421FD9], [0x1800002C, 0x1CE08442],
      [0x180000E0, 0x002B20D1], [0x180000E4, 0x03E0012A], [0x180000E8, 0x01D1002B],
      [0x180000EC, 0x1BD00223], [0x180000F0, 0x2340022A], [0x180000F4, 0x02D1002B],
      [0x180000F8, 0x15D103E0], [0x180000FC, 0x032A01D1], [0x180001F0, 0x78000018],
      [0x180001F4, 0x7C000018], [0x180001F8, 0x82000018], [0x180001FC, 0x88000018],
    ]
    @hex.to_a(crop: [0x18000024,0x180000F4]).should == [
      [0x18000024, 0x22D31FE0], [0x18000028, 0x84421FD9], [0x1800002C, 0x1CE08442],
      [0x180000E0, 0x002B20D1], [0x180000E4, 0x03E0012A], [0x180000E8, 0x01D1002B],
      [0x180000EC, 0x1BD00223], [0x180000F0, 0x2340022A], [0x180000F4, 0x02D1002B],
    ]
  end
end
