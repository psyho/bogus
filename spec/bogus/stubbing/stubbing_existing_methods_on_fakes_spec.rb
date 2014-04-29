 require 'spec_helper'

 describe "Stubbing existing methods on fakes" do
   include Bogus::MockingDSL

   before do
     Bogus.clear
   end

   it "should be possible to stub to_s" do
     foo = fake(:foo) { Samples::Foo }

     stub(foo).to_s { "I'm a foo" }

     expect(foo.to_s).to eq("I'm a foo")
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

     expect(foo.to_s).to eq("I'm a foo")
   end

   class Object
     def sample_method_for_stubbing_existing_methods
     end
   end

   class SampleForStubbingExistingMethods
   end

   it "should be possible to stub arbitrary methods that were defined on Object" do
     foo = fake(:foo) { SampleForStubbingExistingMethods }

     stub(foo).sample_method_for_stubbing_existing_methods { :bar }

     expect(foo.sample_method_for_stubbing_existing_methods).to eq(:bar)
   end
 end
