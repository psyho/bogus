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

  Bogus.fix_ar_classes_for_bogus

  it "makes it possible to stub active record fields" do
    post = fake(:blog_post, name: "hello")

    post.name.should == "hello"
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
end
