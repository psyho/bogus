Fakes in Bogus are essentially lightweight objects that mimic the original
object's interface.

Let's say that we have a `Library` class that is used to manage books and a `Student`,
who can interact with the `Library` in some way.

In order to test the `Student` in isolation, we need to replace the `Library`, with some
test double. Typically, you would do that by creating an anonymous stub/mock object and
stubbing the required methods on it.

Using those stubs, you specify the desired interface of the library object.

The problems with that approach start when you change the `Library` class. For example,
you could rename the `#checkout` method to `#checkout_book`. If you used the standard approach,
where your stubs are not connected in any way to the real implementation, your tests will
keep happily passing, even though the collaborator interface just changed.

Bogus saves you from this problem, because your fakes have the exact same interface as
the real collaborators, so whenever you change the collaborator, but not the tested object,
you will get an exception in your tests.
