require 'spec_helper'

describe "Binary" do

  before :all do
    @bin = OrigenMemoryImage.new("examples/bin1.bin")
  end

  it "code_start_address method works" do
    @bin.start_address.should == 0
  end

  it "to_a method works" do
    @bin.to_a.should == [
      [0x00, 0x1EE0021C], [0x04, 0x22401BE0], [0x08, 0x021C2243],
      [0x0C, 0x18E0021C], [0x10, 0x5A780A43], [0x14, 0x03E0034B],
      [0x18, 0xF7215A78], [0x1C, 0x0A400020], [0x20, 0x22E08442],
      [0x24, 0x22D31FE0], [0x28, 0x84421FD9], [0x2C, 0x1CE08442],
      [0x30, 0x002B20D1], [0x34, 0x03E0012A], [0x38, 0x01D1002B],
      [0x3C, 0x1BD00223], [0x40, 0x2340022A], [0x44, 0x02D1002B],
      [0x48, 0x15D103E0], [0x4C, 0x032A01D1], [0x50, 0x78000018],
      [0x54, 0x7C000018], [0x58, 0x82000018], [0x5C, 0x88000018],
    ]
  end

#  it "to_a method works with partial word" do
#    @bin3 = OrigenMemoryImage.new("examples/hex3.hex")
#    @bin3.to_a.should == [
#      [0x18000000, 0x1EE0021C], [0x18000004, 0x22401BE0], [0x18000008, 0x021C2243],
#      [0x1800000C, 0x18E0021C], [0x18000010, 0x5A780A43], [0x18000014, 0x03E0034B],
#      [0x18000018, 0xF7215A78], [0x1800001C, 0x0A400020], [0x18000020, 0x22E08442],
#      [0x18000024, 0x22D31FE0], [0x18000028, 0x84421FD9], [0x1800002C, 0x1CE08442],
#      [0x180000E0, 0x002B20D1], [0x180000E4, 0x03E0012A], [0x180000E8, 0x01D1002B],
#      [0x180000EC, 0x1BD00223], [0x180000F0, 0x2340022A], [0x180000F4, 0x02D1002B],
#      [0x180000F8, 0x15D103E0], [0x180000FC, 0x032A01D1], [0x180001F0, 0x78000018],
#      [0x180001F4, 0x7C0000],
#    ]
#  end

  it "data_width_in_bytes option works" do
    data = @bin.to_a(data_width_in_bytes: 2)
    data[0].should == [0x00, 0x1EE0]
    data[1].should == [0x02, 0x021C]
    data.size.should == 48
  end

  it "endianness_change option works" do
    data = @bin.to_a(flip_endianness: true)
    data[0].should == [0x00, 0x1C02E01E]
    data[1].should == [0x04, 0xE01B4022]
    data.size.should == 24
  end

  it "endianness_change option works with 128-bit data" do
    data = @bin.to_a(flip_endianness: true)
    @bin.to_a(data_width_in_bytes: 16).should == [
      [0x00, 0x1EE0021C_22401BE0_021C2243_18E0021C],
      [0x10, 0x5A780A43_03E0034B_F7215A78_0A400020], 
      [0x20, 0x22E08442_22D31FE0_84421FD9_1CE08442],
      [0x30, 0x002B20D1_03E0012A_01D1002B_1BD00223], 
      [0x40, 0x2340022A_02D1002B_15D103E0_032A01D1],
      [0x50, 0x78000018_7C000018_82000018_88000018],
    ]
    @bin.to_a(data_width_in_bytes: 16, flip_endianness: true).should == [
      [0x00, 0x1C02E018_43221C02_E01B4022_1C02E01E],
      [0x10, 0x2000400A_785A21F7_4B03E003_430A785A], 
      [0x20, 0x4284E01C_D91F4284_E01FD322_4284E022],
      [0x30, 0x2302D01B_2B00D101_2A01E003_D1202B00], 
      [0x40, 0xD1012A03_E003D115_2B00D102_2A024023],
      [0x50, 0x18000088_18000082_1800007C_18000078],
    ]
  end

  it "creating from a string works" do
    str = <<-END
      00001101000101010000111100010011
      00001110000101000001000000010010
      00000000000000000000010000010111
      00000100000000110000010100000110
    END
    @hex = OrigenMemoryImage.new(str, source: String)
    @hex.start_address.should == 0
    @hex.file_name.should == 'From source string'
    @hex.to_a.should == [
      [0x0, 0x0D150F13], [0x4, 0x0E141012],
      [0x8, 0x00000417], [0xC, 0x04030506],
    ]
  end
  
  it "crop option works" do
    @bin.to_a(crop: [0x24]).should == [
      [0x24, 0x22D31FE0], [0x28, 0x84421FD9], [0x2C, 0x1CE08442],
      [0x30, 0x002B20D1], [0x34, 0x03E0012A], [0x38, 0x01D1002B],
      [0x3C, 0x1BD00223], [0x40, 0x2340022A], [0x44, 0x02D1002B],
      [0x48, 0x15D103E0], [0x4C, 0x032A01D1], [0x50, 0x78000018],
      [0x54, 0x7C000018], [0x58, 0x82000018], [0x5C, 0x88000018],
    ]
    @bin.to_a(crop: [0x24, 0x44]).should == [
      [0x24, 0x22D31FE0], [0x28, 0x84421FD9], [0x2C, 0x1CE08442],
      [0x30, 0x002B20D1], [0x34, 0x03E0012A], [0x38, 0x01D1002B],
      [0x3C, 0x1BD00223], [0x40, 0x2340022A], [0x44, 0x02D1002B],
    ]
  end
  
  it "has_start_record method works" do
    @bin.has_start_record.should == false
  end
end
