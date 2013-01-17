module Bogus
  module RecordInteractions
    def __shadow__
      @__shadow__ ||= Shadow.new(self)
    end

    def __record__(method, *args, &block)
      __shadow__.run(method, *args, &block)
    end
  end
end
