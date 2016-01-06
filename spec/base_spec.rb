require 'spec_helper'

describe "Base" do

  it "unsupported format raises exception" do
    lambda { OrigenMemoryImage.new("examples/base1.base") }.should raise_error
  end

end
