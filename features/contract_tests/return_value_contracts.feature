Feature: Return value contracts

  In order to be able to record the stubbed value, Bogus requires that the block
  you pass when stubbing is free of side effects and idempotent.

  If it's not, the behavior of contract verification is not defined.

  Background:
    Given a file named "foo.rb" with:
    """ruby
    class SessionController
      def initialize(authentication_service)
        @authentication_service = authentication_service
      end

      def create(params)
        @authentication_service.authenticate(params[:login], params[:password])
        :render_welcome
      rescue
        :render_error
      end
    end

    class WrongPassword < StandardError
    end

    class AuthenticationService
      def initialize(user_db)
        @user_db = user_db
      end

      def authenticate(login, password)
        unless @user_db[login] == Digest::SHA1.hexdigest(password)
          raise WrongPassword
        end
      end
    end
    """
    And a spec file named "session_controller_spec.rb" with:
    """ruby
    describe SessionController do
      fake(:authentication_service)
      let(:controller) { SessionController.new(authentication_service) }

      it "logs in the user with valid data" do
        stub(authentication_service).authenticate('foo', 'bar')

        controller.create(login: 'foo', password: 'bar').should == :render_welcome
      end

      it "fails with invalid data" do
        stub(authentication_service).authenticate('baz', 'bar') { raise WrongPassword }

        controller.create(login: 'baz', password: 'bar').should == :render_error
      end
    end
    """

  Scenario: Bogus makes sure that all the return values recorded by stubbing are also present in tests of the real object
    Then spec file with following content should fail:
    """ruby
    describe AuthenticationService do
      verify_contract(:authentication_service)

      it "logs in the user" do
        service = AuthenticationService.new('foo' => Digest::SHA1.hexdigest('bar'))
        expect {
          service.authenticate('foo', 'bar')
        }.not_to raise_error
      end
    end
    """

  Scenario: Bogus does not fail the tests if all the recorded values have been also recorded on the real object
    Then spec file with following content should pass:
    """ruby
    describe AuthenticationService do
      verify_contract(:authentication_service)

      it "logs in the user" do
        service = AuthenticationService.new('foo' => Digest::SHA1.hexdigest('bar'))
        expect {
          service.authenticate('foo', 'bar')
        }.not_to raise_error
      end

      it "raises WrongPassword with incorrect credentials" do
        service = AuthenticationService.new('foo' => Digest::SHA1.hexdigest('bar'))
        expect {
          service.authenticate('baz', 'bar')
        }.to raise_error(WrongPassword)
      end
    end
    """

