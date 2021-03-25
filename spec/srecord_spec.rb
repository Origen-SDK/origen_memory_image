require 'spec_helper'

describe "SRecord" do

  before :all do
    @srec = OrigenMemoryImage.new("examples/srec1.s19")
  end

  it "code_start_address method works" do
    @srec.start_address.should == 0x3F000410
  end
  
  it "code start address is accurate when to_a is called first" do
    @srec.to_a
    @srec.start_address.should == 0x3F000410
  end

  it "to_a method works" do
    @srec.to_a.should == [
      [1056964640, 0x18F09FE5], [1056964644, 418422757], [1056964648, 418422757],
      [1056964652, 418422757], [1056964656, 418422757], [1056964660, 15737059],
      [1056964664, 351313893], [1056964668, 351313893], [1056965232, 4094033983],
      [1056965236, 270598208], [1056965240, 2013265983], [1056966064, 1609629488],
      [1056966068, 457771104], [1056966072, 1609629488], [1056966076, 440993888],
      [1056966384, 1883701248]
    ]
  end

  it "to_a method works with partial word" do
    @srec2 = OrigenMemoryImage.new("examples/srec2.s19")
    @srec2.to_a.should == [
      [1056964640, 0x18F09FE5], [1056964644, 418422757], [1056964648, 418422757],
      [1056964652, 418422757], [1056964656, 418422757], [1056964660, 15737059],
      [1056964664, 351313893], [1056964668, 351313893], [1056965232, 4094033983],
      [1056965236, 270598208], [1056965240, 7864320], [1056966064, 1609629488],
      [1056966068, 457771104], [1056966072, 1609629488], [1056966076, 440993888],
      [1056966384, 1883701248]
    ]
  end

  it "to_a method works with partial word left justified" do
    @srec2 = OrigenMemoryImage.new("examples/srec2.s19", ljust_partial_data: true)
    @srec2.to_a.should == [
      [1056964640, 0x18F09FE5], [1056964644, 418422757], [1056964648, 418422757],
      [1056964652, 418422757], [1056964656, 418422757], [1056964660, 15737059],
      [1056964664, 351313893], [1056964668, 351313893], [1056965232, 4094033983],
      [1056965236, 270598208], [1056965240, 2013265920], [1056966064, 1609629488],
      [1056966068, 457771104], [1056966072, 1609629488], [1056966076, 440993888],
      [1056966384, 1883701248]
    ]
  end

  it "code_start_address method works with 3-byte address start" do
    @srec2 = OrigenMemoryImage.new("examples/srec2.s19")
    @srec2.start_address.should == 0x000410
  end

  it "code_start_address method works with 2-byte address start" do
    @srec3 = OrigenMemoryImage.new("examples/srec3.s19")
    @srec3.start_address.should == 0x0410
  end

  it "data_width_in_bytes option works" do
    data = @srec.to_a(data_width_in_bytes: 2)
    data[0].should == [1056964640, 0x18F0]
    data[1].should == [1056964642, 0x9FE5]
    data.size.should == 32
  end

  it "endianness_change option works" do
    @srec.to_a(endianness_change: true).should == [
      [1056964640, 0xE59FF018], [1056964644, 3852464152], [1056964648, 3852464152],
      [1056964652, 3852464152], [1056964656, 3852464152], [1056964660, 3810586624],
      [1056964664, 3852464148], [1056964668, 3852464148], [1056965232, 1056966388],
      [1056965236, 1073750288], [1056965240, 1056964728], [1056966064, 822079583],
      [1056966068, 1611155739], [1056966072, 822079583], [1056966076, 1611155738],
      [1056966384, 18288]
    ]
  end

  it "crop option works" do
    @srec.to_a(crop: [1056964660]).should == [
      [1056964660, 15737059],
      [1056964664, 351313893], [1056964668, 351313893], [1056965232, 4094033983],
      [1056965236, 270598208], [1056965240, 2013265983], [1056966064, 1609629488],
      [1056966068, 457771104], [1056966072, 1609629488], [1056966076, 440993888],
      [1056966384, 1883701248]
    ]
    @srec.to_a(crop: [1056964660,1056965240]).should == [
      [1056964660, 15737059],
      [1056964664, 351313893], [1056964668, 351313893], [1056965232, 4094033983],
      [1056965236, 270598208], [1056965240, 2013265983]
    ]
    lambda { @srec.to_a(crop: [1056964660,1056965240,22]) }.should raise_error
  end
  
  it "returns lowest address when start record is missing" do
    @srec_no_start = OrigenMemoryImage.new("examples/srec1_no_start.s19")
    @srec_no_start.start_address.should == 0x3F000020
  end
end
