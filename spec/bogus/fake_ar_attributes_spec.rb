require 'spec_helper'
require 'active_record'
require 'nulldb'

describe "Stubbing ActiveRecord::Base subclasses" do
  ActiveRecord::Schema.verbose = false
  ActiveRecord::Base.establish_connection :adapter => :nulldb

  ActiveRecord::Schema.define do
    create_table :blog_posts do |t|
      t.string :name
      t.string :author
    end
  end

  class BlogPost < ActiveRecord::Base
    def author
      "#{self[:author]}!"
    end
  end

  include Bogus::MockingDSL

  before do
    Bogus.configure do |c|
      c.fake_ar_attributes = true
    end
  end

  it "makes it possible to stub active record fields" do
    post = fake(:blog_post, name: "hello")

    post.name.should == "hello"
  end

  it "works only when enabled in configuration" do
    Bogus.configure do |c|
      c.fake_ar_attributes = false
    end

    expect {
      fake(:blog_post, name: "hello")
    }.to raise_error(NameError)
  end

  it "does not break the regular behavior of overwritten methods" do
    post = BlogPost.new

    post.name = "hello world"

    post.name.should == "hello world"
  end

  it "does not overwrite existing methods" do
    post = BlogPost.new

    post.author = "Batman"

    post.author.should == "Batman!"
  end

  class ExampleForActiveRecordAttributes
    def foo(x)
    end
  end

  it "does not interfere with non-ar classes" do
    fake = fake(:example_for_active_record_attributes)

    fake.foo(1)

    fake.should have_received.foo(1)
  end

  after do
    Bogus.configure do |c|
      c.fake_ar_attributes = false
    end
  end
end
