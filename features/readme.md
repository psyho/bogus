Bogus is a library that aims to reduce the risks associated with isolated unit testing.  

## The problem

It is not uncommon to encounter code like this in isolated unit tests:

    it "returns the average score" do
      scores = stub(get: [5, 9])
      students = stub(all: ["John", "Mary"])

      report_card = ReportCard.new(scores, students)

      report_card.average_score.should == 7
    end

_NOTE:  In the above example we use mocha syntax, but this patten is common
to all the major mocking frameworks_

The test above not only ensures that `ReportCard` can calculate the average score for all the students, but it also specifies how this class will interact with it's collaborators and what those collaborators will be.

This style of testing enables us to practice so called *programming by wishful thinking*.  We can implement `ReportCard` and get it to work before it's collaborators are implemented.  This way we can design our system top-down and only implement what we need. This is a Very Good Thing(tm).

However, the same freedom that comes from not having to implement the collaborators, can quickly turn against us. Once implement `ReportCard`, what test will tell us that `Scores` and `Students` are not implemented yet?

The kind of stubbing that you see in the example above requires us to write integrated or end-to-end test *just to make sure that the objects we implemented fit together*.  This is a problem, because those tests can be quite slow and hard to set up in a way that covers all the integration points between our objects.

Another problem is that it's quite likely that `Students` and `Scores` will be collaborating with more objects than the `ReportCard`. If so, you will find yourself typing code like this over and over again:

    students = stub(all: ["John", "Mary"])

This is duplication. It is also a problem, because if you decide to change the interface of the `Students` class, suddenly you will have to remember every place you created that stub and fix it. Your tests won't help you, because they don't have any idea what the `Students` interface should look like.

## The solution

Bogus makes your test doubles more assertive. They will no longer be too shy to tell you: "Hey, you are stubbing the wrong thing!".

Let's reexamine our previous example, this time Bogus-style:

    it "returns the average score" do
      students = fake(:students, get: [5, 9])
      scores = fake(:scores, all: ["John", "Mary"])

      report_card = ReportCard.new(scores, students)

      report_card.average_score.should == 7
    end

Can you spot the difference? Not much, huh?

However, the code above will not only make sure that the `ReportCard` works, it will also make sure that classes `Students` and `Scores` exist and have an interface that matches what you stub on them.

## DRY out your fake definitions

By now you know how Bogus can help you with making sure that your stubs match the interface of your production classes. However, the attentive reader has probably spotted a problem with the solution above already. If all you need to change in your tests is the word `stub` to `fake` and give it some name, then how is that any better when it comes to scattering the fake interface definition all over your specs?

The answer is: it's just slightly better. The reason it's better is that you only need to ever stub methods that return meaningful values. Let us explain.

### Tell-don't-ask methods

Let's say we have a `PushNotifier` class:

    class PushNotifier
      def notify_async(messages)
      end
    end

Now if you test an object that collaborates with our `PushNotifier`, you would do something like this:

    fake(:push_notifier)

    it "send push notifications when comment is added" do
      comment_adder = CommentAdder.new(push_notifier)

      comment_adder.add("Hello world!")

      push_notifier.should have_received.notify_async("Comment: 'Hello world!' added.")
    end

While not really impressive, this feature is worth mentioning because it will eliminate a lot of the mocking and stubbing from your tests.

### Global fake configuration

Bogus also has a solution for DRYing stubbing of the methods that return values. All you need to do is to provide a reasonable default return value for those methods in the global fake configuration.

      Bogus.fakes do
        fake(:students) do
          all []
        end

        fake(:scores) do
          get []
        end
      end

Now you will only need to stub those methods when you actually care about their return value, which is exactly what we want.

## Contract tests

Bogus is not the only mocking library to implement fakes and safe mocking. However, it is the first library to implement the concept of contract tests [as defined by J. B. Rainsberger][contracts].

Let's start with an example:

    stub(scores).get(["John", "Mary"]) { [5, 9] }

We already know that Bogus makes sure for us that the `Scores` class exists, has a `get` method and that this method can be called with one argument.

It would also be nice to know that the input/output that we stub makes sense for this method.

Contract tests are an idea, that whenever we stub `Scores#get` with argument `["John", "Mary"]` to return the value `[5, 9]`, we should add a test for the Scores class, that calls method `get` with those same arguments and have the same return value.

A contract test like that could look like this:

    it "returns scrores for students" do
      scores = Scores.new(redis)
      scores.add("John", 5)
      scores.add("Mary", 9)

      scores.get(["John", "Mary"]).should == [5, 9]
    end

Obviously Bogus won't be able to write those tests for you. However it can remind you if you forget to add one.

To add contract test verification, the only thing you need to do is add the line:

    verify_contract(:students)

to your tests for `Students` class.

[contracts]: http://www.infoq.com/presentations/integration-tests-scam
