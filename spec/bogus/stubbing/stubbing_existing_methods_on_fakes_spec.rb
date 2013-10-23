 require 'spec_helper'

 describe "Stubbing existing methods on fakes" do
   include Bogus::MockingDSL

   before do
     Bogus.clear
   end

   it "should be possible to stub to_s" do
     foo = fake(:foo) { Samples::Foo }

     stub(foo).to_s { "I'm a foo" }

     foo.to_s.should == "I'm a foo"
   end

   it "should be possible to mock to_s" do
     foo = fake(:foo) { Samples::Foo }

     mock(foo).to_s { "I'm a foo" }

     expect {
       Bogus.after_each_test
     }.to raise_exception(Bogus::NotAllExpectationsSatisfied)
   end


   it "should be possible to stub to_s on anonymous fake" do
     foo = fake(to_s: "I'm a foo")

     foo.to_s.should == "I'm a foo"
   end
 end
