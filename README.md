# Bogus

[![build status](https://secure.travis-ci.org/psyho/bogus.png)](http://travis-ci.org/psyho/bogus)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/psyho/bogus)

## What is Bogus?

Bogus aims to make your unit tests more reliable by ensuring that you don't stub or mock methods that don't actually exist in the mocked objects.

Bogus provides facilities to create *fakes* - test doubles that have the same interface as the doubled class.

Another feature of Bogus is *safe stubbing*, which does not allow you to stub methods that don't exist or don't match the signature specified when stubbing.

A unique feature of Bogus are the *contract tests*, which reduce the need for integrated tests to a minimum by ensuring that the things you stub match how the object really behaves.

## Documentation

[You can find our (executable) documentation on Relish.][docs]

## License

MIT. See the LICENSE file.

## Authors

* [Adam Pohorecki](http://github.com/psyho)
* [Paweł Pierzchała](http://github.com/wrozka)
* [Marek Nowak](https://github.com/yundt)

[docs]: http://www.relishapp.com/bogus/bogus/docs 
