Feature: fake_ar_attributes

  Instances of ActiveRecord::Base subclasses are different then most of the objects you might encounter because the field access on those classes is done by taking advantage of Ruby's `method_missing` functionality.

  Unfortunately, in order to create a fake, Bogus has to examine all of the methods that are defined on a given class and herein lies the problem, the methods that you would expect to have on your ActiveRecord models do not exist:

      class BlogPost < ActiveRecord::Base
      end

      blog_post = BlogPost.new
      blog_post.respond_to?(:name) # => true
      blog_post.method(:name) # raises NameError

  Normally, this would prevent Bogus from being able to fake those methods, but in the case of ActiveRecord we can figure out those fields by looking at the `BlogPost.columns` property. Based on that we can define those accessors on the created fake. If you wish to take advantage of that, you just need to flip a configuration switch:

      Bogus.configure do |c|
        c.fake_ar_attributes = true
      end

  Scenario: Adding missing accessors to AR classes
    Given a file named "blog_post.rb" with:
    """ruby
    require 'active_record'
    require 'nulldb'

    ActiveRecord::Schema.verbose = false
    ActiveRecord::Base.establish_connection :adapter => :nulldb

    ActiveRecord::Schema.define do
      create_table :blog_posts do |t|
        t.string :name
        t.string :tags
      end
    end

    class BlogPost < ActiveRecord::Base
    end

    Bogus.configure do |c|
      c.fake_ar_attributes = true
    end
    """

    Then the following test should pass:
    """ruby
    require_relative 'blog_post'

    post = fake(:blog_post, name: "the name")
    stub(post).tags { "foo, bar" }

    expect(post.name).to eq("the name")
    expect(post.tags).to eq("foo, bar")
    """
