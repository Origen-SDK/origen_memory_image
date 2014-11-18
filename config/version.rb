# Best not to edit this by hand, it will be overwritten by the tag script
class MemoryImageApplication < RGen::Application

  MAJOR = 0
  MINOR = 0
  BUGFIX = 0
  DEV = 0

  VERSION = "v" + [MAJOR, MINOR, BUGFIX].join(".") + (DEV ? ".dev#{DEV}" : '')

end
