# This file will be required by RGen before your target is loaded, you 
# can use this to require all of your files, which is the easiest way
# to get started. As your experience grows you may wish to require only the
# minimum files required to allow the target to be initialized and let 
# each class require its own dependencies.
#
# It is recommended that you keep all of your application logic in lib/
# The lib directory has already been added to the search path and so any files
# in there can be referenced from here with a relative path.
#
# Note that pattern files do not need to be referenced from here and these
# will be located automatically by rgen.
#
# Examples
# --------
# This says load the file "lib/pioneer.rb" the first time anyone makes a 
# reference to the class name 'Pioneer'.
#autoload :Pioneer,   "pioneer"
#
# This is generally preferable to using require which will load the file
# regardless of whether it is needed by the current target or not:
#require "pioneer"
#
# Sometimes you have to use require however:-
#   1. When defining a test program interface:
#require "interfaces/j750"
#   2. If you want to extend a class defined by an imported plugin, in
#      this case your must use required and supply a full path (to distinguish
#      it from the one in the parent application):
#require "#{RGen.root}/c90_top_level/p2"

# Plugins should not use a wildcard import of the lib directory to help
# prevent long start up times, only require what is necessary to boot and
# use autoload for everything else.
module MemoryImage
  autoload :Base, "memory_image/base"
  autoload :SRecord, "memory_image/s_record"
  autoload :Hex, "memory_image/hex"
end
require "memory_image"