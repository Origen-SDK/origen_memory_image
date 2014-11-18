$VERBOSE=nil  # Don't care about world writable dir warnings and the like

# If running on windows, can't use RGen helpers 'till we load it...
if RUBY_PLATFORM == 'i386-mingw32'
  `where rgen`.split("\n").find do |match|
    match =~ /(.*)\\bin\\rgen$/
  end
  rgen_top = $1.gsub("\\", "/")
else
  rgen_top = `which rgen`.strip.sub("/bin/rgen", "")
end

$LOAD_PATH.unshift "#{rgen_top}/lib"
$LOAD_PATH.unshift "#{rgen_top}/vendor/lib"

require "rgen"
require "#{RGen.top}/spec/format/rgen_formatter"

RGen.app.require_environment!
require "#{RGen.root}/config/development.rb"

RSpec.configure do |config|
  config.formatter = RGenFormatter
end

def load_target(target="debug")
  RGen.target.switch_to target
  RGen.target.load!
end
