# Bogus

## What is Bogus?

Bogus aims to make your unit tests more reliable by ensuring that you don't stub or mock methods that don't actually exist in the mocked objects.

## What are fakes?

Fakes are alternative implementations of classes for testing purposes.
In most cases, fakes are just named stubs: they don't implement the logic (otherwise they should be tested too), but they have the same interface as the real object and they make it easier to remove duplication in your stubs.

## Stubs and mocks scatter the interface specification all over your specs

Let's assume that you have a couple of classes that share a collaborator. In this case we have a finds_users object that allows finding users by location and suggests_followings and lists_users_near_city that use it in turn to compute a list of users that match some criteria.

```ruby
class FindsUsers
  takes :users_repository

  def near_point(location, distance_in_km); 
    # do something with users_repository and return a list of users
  end
end

class Geocoder
  takes :http_client

  def location_for(address)
    # do something to http_client and return location
  end
end

class SuggestsFollowings
  takes :finds_users

  def suggestions_for(user)
    finds_users.near_point(user.location, 50).select{|user| user.followers_count > 10}
  end
end

class ListsUsersNearCity
  takes :finds_users, :geocoder

  def users(city)
    city_location = geocoder.location_for(city.name)
    finds_users.near_point(city_location, 10)
  end
end
```

Typically, when testing SuggestsFollowings and ListsUsersNearCity you'd have code like this in your specs:

```ruby
describe SuggestsFollowings
  let(:finds_users) { stub(:finds_users) }
  let(:user) { new_user }

  subject { SuggestsFollowings.new(finds_users) }

  it "returns users with follower count of 10 or more" do
    user_with_followers = new_user(followers_count: 10)
    users = [new_user(followers_count: 5), user_with_followers]

    finds_users.should_receive(:near_point).with(user.location, 50).and_return(users)

    subject.suggestions_for(user).should == [user_with_followers]
  end

  # ...
end

describe ListsUsersNearCity
  let(:finds_users) { stub(:finds_users) }
  let(:geocoder) { stub(:geocoder) }
  let(:city) { new_city(name: "New York") }

  subject { ListsUsersNearCity.new(finds_users, geocoder) }

  it "returns users near center of the city" do
    location = Location.new(1, 2)
    users = [new_user, new_user]

    geocoder.should_receive(:location_for).with("New York").and_return(location)
    finds_users.should_receive(:near_point).with(location, 10).and_return(users)

    subject.users(city).should == users
  end

  # ...
end
```

Notice how the stubbing/mocking code is duplicated between both specs.
This might not be a huge problem in a small project, but as your codebase grows, there might be more and more objects that interact with finds_users, and the more objects interact with finds_users, the more places it's interface is specified in using stubbing or mock expectations.

## Bogus to the rescue!

Bogus is aimed to help you remove duplication in specifying interfaces from your specs.
It will reduce the need for integration testing, because with Bogus, you make sure that the test doubles you use have the same interface as the real object, while still allowing you to test in isolation and benefit from that.

So how would your tests look like if you used Bogus?

```ruby
require 'bogus/rspec'

Bogus.configure do |config|
  config.spy_by_default = true
  config.stub_dsl = :rspec # only :rspec available for now
end

shared_context 'fakes' do
  fake(:geocoder) # same as let(:geocoder) { Bogus.fake_for(:geocoder.to_s.classify) }
  fake(:finds_users)
end

describe SuggestsFollowings
  include_context "fakes"

  let(:user) { new_user }

  subject { SuggestsFollowings.new(finds_users) }

  it "returns users with follower count of 10 or more" do
    user_with_followers = new_user(followers_count: 10)
    users = [new_user(followers_count: 5), user_with_followers]

    # this will actually fail if FindsUsers does not have a near_point method
    # that takes 2 arguments
    finds_users.should_receive(:near_point).with(user.location, 50).and_return(users)

    subject.suggestions_for(user).should == [user_with_followers]
  end

  # ...
end

describe ListsUsersNearCity
  include_context "fakes"

  let(:city) { new_city(name: "New York") }

  subject { ListsUsersNearCity.new(finds_users, geocoder) }

  it "returns users near center of the city" do
    location = Location.new(1, 2)
    users = [new_user, new_user]

    geocoder.should_receive(:location_for).with("New York").and_return(location)
    finds_users.should_receive(:near_point).with(location, 10).and_return(users)

    subject.users(city).should == users
  end

  # ...
end
```

As you can see, by using Bogus you can keep writing truly isolated unit tests just like you are used to, but with higher degree of security, because Bogus makes sure, that the methods you are stubbing actually exist and take same arguments.

## Spies vs stubs

You can also take advantage of the built-in spying facilities in Bogus:

```ruby
describe ListsUsersNearCity
  include_context "fakes"

  let(:city) { new_city(name: "New York") }
  let(:location) { Location.new(1, 2) }
  let(:users) { [new_user, new_user] }

  subject { ListsUsersNearCity.new(finds_users, geocoder) }

  before do
    geocoder.stub(:location_for => location)
    finds_users.stub(near_point => users)

    @returned_users = subject.users(city)
  end

  it "returns users near center of the city" do
    @returned_users.should == users
  end

  it "geocodes the city name" do
    geocoder.should have_received(:location_for).with(city.name)
  end

  it "lists users in the geocoded location" do
    finds_users.should have_received(:near_point).with(location, 10)
  end

  # ...
end
```

## Bogus and commands

By default, fakes created by Bogus are nil-objects.
This is particularly useful when dealing with "command" methods or if you follow the "tell, don't ask" principle.

```ruby
class SendsEmailNotifications
  def notify_password_changed(user)
    # do something
  end
end

class Logger
  def info(*message)
  end
end

class ChangesPassword
  takes :sends_email_notifications, :logger

  def change_password(user, old_pass, new_pass)
    # change user password
    user.password = new_pass if user.password == old_pass

    # notify by email
    sends_email_notifications.notify_password_changed(user)

    # and log
    logger.info("User", user.name, "changed password")
  end
end

describe ChangesPassword do
  fake(:sends_email_notifications)
  fake(:logger)

  let(:user) { new_user }

  subject{ ChangesPassword.new(sends_email_notifications, logger) }

  it "sends the email notification" do
    subject.change_password(user, 'old', 'new')
    
    sends_email_notifications.should have_received(:notify_password_changed).with(user)
  end
end
```

The beautiful thing is, that even if you don't care about testing something (like logging in this example), you still get the benefit of ensuring that the interface matches, even in a fully isolated test.

## Contracts

Being able to make sure that the methods you stub actually exist is neat, but why stop there?
You can define arbitrary contracts on arguments, return values and exceptions thrown to make sure that the interface you specify in different spec files is really consistent.

```ruby
Bogus.contract(:geocoder) do
  arguments(:location_for) do |address|
    address.should_not be_nil
    address.should be_an_instance_of(String)
  end

  return_value(:location_for) do |value|
    value.should be_an_instance_of(Location)
  end

  exceptions(:location_for) do |exception_class|
    exception_class.should be_one_of(Geocoder::NoResults, Geocoder::HttpError)
  end
end
```

## License

MIT. See the LICENSE file.

## TODO:

Everything. This is a README driven project.

## Author

Adam Pohorecki
