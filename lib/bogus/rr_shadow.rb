module Bogus
  class RRShadow
    extend Bogus::Takes

    takes :rr_proxy, :object

    def mock
      rr_proxy.mock(object)
    end

    def stub
      rr_proxy.stub(object)
    end
  end
end
