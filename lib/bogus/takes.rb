module Bogus
  module Takes
    def takes(*args)
      include Dependor::Constructor(*args)
      attr_reader(*args)
    end
  end
end
