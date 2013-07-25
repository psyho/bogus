module Bogus
  module Anything
    def self.==(other)
      true
    end

    def self.inspect
      "anything"
    end
  end
end
