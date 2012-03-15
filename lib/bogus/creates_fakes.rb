module Bogus
  class CreatesFakes
    def create(klass)
      klass.new
    end
  end
end
