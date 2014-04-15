shared_examples_for "stubbing methods with keyword arguments" do
  it "can spy on stubbed methods" do
    stub(subject).foo(any_args)

    subject.foo(x: "test")

    subject.should have_received.foo(x: "test")
    subject.should_not have_received.foo(x: "baz")
  end

  it "can mock methods with keyword arguments" do
    mock(subject).foo(x: 1) { :return }

    subject.foo(x: 1).should == :return

    expect { Bogus.after_each_test }.not_to raise_error
  end

  it "can stub methods with keyword arguments" do
    stub(subject).foo(x: "bar") { :return_value }

    subject.foo(x: "bar").should == :return_value
  end

  it "raises on error on unknown keyword" do
    expect {
      stub(subject).foo(x: "bar", baz: "baz")
    }.to raise_error(ArgumentError)
  end

  it "does not overwrite the method signature" do
    stub(subject).foo(x: 1)

    expect {
      subject.foo(bar: 1)
    }.to raise_error(ArgumentError)
  end
end

shared_examples_for "stubbing methods with double splat" do
  it "can spy on stubbed methods" do
    stub(subject).bar(any_args)

    subject.bar(x: "test", z: "spec")

    subject.should have_received.bar(x: "test", z: "spec")
    subject.should_not have_received.bar(y: "baz")
  end

  it "can mock methods with keyword arguments" do
    mock(subject).bar(x: 1, z: 2) { :return }

    subject.bar(x: 1, z: 2).should == :return

    expect { Bogus.after_each_test }.not_to raise_error
  end

  it "can stub methods with keyword arguments" do
    stub(subject).bar(x: "bar", z: "bar") { :return_value }

    subject.bar(x: "bar", z: "bar").should == :return_value
  end
end
