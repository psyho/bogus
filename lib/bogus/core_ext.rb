# This monkey patch should not break Ruby compatibility
# but is necessary because MRI, instead of calling object.kind_of?(module),
# calls the C function, which implements kind_of. This makes
# using fake objects in switch cases produce unexpected results:
#
#   fake = fake(:library) { Library }
#
#   case fake
#   when Library then "bingo!"
#   else raise "oh noes!"
#   end
#
# Without the patch, the snippet above raises 'oh noes!'
# instead of returning 'bingo!'.
class Module
  # don't warn about redefining === method
  Bogus::Support.supress_warnings do
    alias :__trequals__ :===

    def ===(object)
      # BasicObjects do not have kind_of? method
      return __trequals__(object) unless Object.__trequals__(object)
      object.kind_of?(self)
    end
  end
end
