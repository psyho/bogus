Feature: fake_ar_attributes

  Instances of ActiveRecord::Base subclasses are different then most of the objects you might encounter because the field access on those classes is done by taking advantage of Ruby's `method_missing` functionality.

  Unfortunately, in order to create a fake, Bogus has to examine all of the methods that are defined on a given class and herein lies the problem: the methods that you would expect to have on your ActiveRecord models do not exist.

  In order to fix that, you could use a simple trick:

      class BlogPost < ActiveRecord::Base
        def name
          super
        end

        def tags
          super
        end
      end

  This is very repetitive and rather boring, so Bogus can create methods like this for you automatically. All you need to do is specify in the configuration that you want Bogus to add ActiveRecord fields to fakes:

      Bogus.configure do |c|
        c.fake_ar_attributes = true
      end

  Scenario: Adding missing accessors to AR classes
    Given a file named "foo.rb" with:
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
    post = fake(:blog_post, name: "the name")
    stub(post).tags { "foo, bar" }

    post.name.should == "the name"
    post.tags.should == "foo, bar"
    """
