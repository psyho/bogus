# This monkey patch should not break Ruby compatibility
# but is necessary because MRI, insead of calling object.kind_of?(module),
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
    def ===(object)
      object.kind_of?(self)
    end
  end
end
