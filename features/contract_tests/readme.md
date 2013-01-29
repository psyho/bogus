Whenever you write test code like this:

    mock(library).checkout("Moby Dick") { raise NoSuchBookError }

There are some assumptions this code makes:

1. There is an object in my system that can play the role of a library.
2. The library object has a `#checkout` method that takes one argument.
3. The system under test is supposed to call `#checkout` with argument `"Moby Dick"` at least once.
4. There is some context in which, given argument "Moby Dick", the `#checkout` method raises `NoSuchBookError`.

While using fakes makes sure that the assumptions 1 and 2 are satisfied, and assumption number 3 is verified by the mocking system, in order to make sure that the assumption no 4 is also true, you need to write a test for the library object.

Bogus will not be able to write that test for you, but it can remind you that you should do so.

Whenever you use named fakes:

    fake(:library)

Bogus will remember any interactions set up on that fake.

If you want to verify that you remembered to test all the scenarios specified by stubbing/spying/mocking on the fake object, you can put the following code in the tests for "the real thing" (i.e. the Library class in our example):

    verify_contract(:library)

This will record all of the interactions you make with that class and make the tests fail if you forget to test some scenario that you recorded using a fake object.
