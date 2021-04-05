require 'spec_helper'

describe "IntelHex" do

  it "start_address method works" do
    hex = OrigenMemoryImage.new("examples/intel2.hex")
    hex.start_address.should == 0
  end

  it "to_a method works" do
    hex = OrigenMemoryImage.new("examples/intel1.hex")
    hex.to_a.should == [
      [0x100, 0x21460136],
      [0x104, 0x01214701],
      [0x108, 0x36007EFE],
      [0x10C, 0x09D21901],
      [0x110, 0x2146017E],
      [0x114, 0x17C20001],
      [0x118, 0xFF5F1600],
      [0x11C, 0x21480119],
      [0x120, 0x194E7923],
      [0x124, 0x46239657],
      [0x128, 0x78239EDA],
      [0x12C, 0x3F01B2CA],
      [0x130, 0x3F015670],
      [0x134, 0x2B5E712B],
      [0x138, 0x722B7321],
      [0x13C, 0x46013421]
    ]    

    hex = OrigenMemoryImage.new("examples/intel2.hex")
    hex.to_a.should == [
      [0x00220100, 0x21460136],
      [0x00220104, 0x01214701],
      [0x00220108, 0x36007EFE],
      [0x0022010C, 0x09D21901],
      [0x00220110, 0x2146017E],
      [0x00220114, 0x17C20001],
      [0x00220118, 0xFF5F1600],
      [0x0022011C, 0x21480119],
      [0x00230120, 0x194E7923],
      [0x00230124, 0x46239657],
      [0x00230128, 0x78239EDA],
      [0x0023012C, 0x3F01B2CA],
      [0x00230130, 0x3F015670],
      [0x00230134, 0x2B5E712B],
      [0x00230138, 0x722B7321],
      [0x0023013C, 0x46013421]
    ]    
  end

  it "has_start_record method works" do
    hex = OrigenMemoryImage.new("examples/intel1.hex")
    hex.has_start_record.should == false
    hex = OrigenMemoryImage.new("examples/intel2.hex")
    hex.has_start_record.should == false
  end
end
