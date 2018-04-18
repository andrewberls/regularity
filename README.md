## Regularity - Regular expressions for humans

Regularity is a friendly regular expression builder for Ruby. Regular expressions are a powerful way of
pattern-matching against text, but too often they are 'write once, read never'. After all, who wants to try and deciper

```ruby
/^[0-9]{3}-[A-Za-z]{2}#?[a|b]a{2,4}\$$/
```

when you could express it as:

```ruby
Regularity.new
  .start_with(3, :digits)
  .then('-')
  .then(2, :letters)
  .maybe('#')
  .one_of(['a','b'])
  .between([2,4], 'a')
  .end_with('$')
```

While taking up a bit more space, Regularity expressions are much more readable than their cryptic counterparts.

### Installation

```
gem install regularity
```

### Usage

Regularity objects are just plain ol Ruby objects that act like regexes - `method_missing` delegates to a regex object,
so you can go ahead and call `=~` and `match` and [all your other favorite methods](http://www.ruby-doc.org/core-1.9.3/Regexp.html)
on them and it will just work <sup>TM</sup>

### DSL methods

Most methods accept the same pattern signature - you can either specify a patterned constraint such as `then("xyz")`,
or a numbered constraint such as `then(2, :digits)`. The following special identifers are supported:

```
:digit        => '[0-9]'
:lowercase    => '[a-z]'
:uppercase    => '[A-Z]'
:letter       => '[A-Za-z]'
:alphanumeric => '[A-Za-z0-9]'
:whitespace   => '\s'
:space        => ' '
:tab          => '\t'
```

It doesn't matter if the identifier is pluralized, i.e. `then(2, :letters)` works in addition to `then(1, :letter)`


The following methods are supported:

`start_with(pattern)`: The line must start with the specified pattern

`append(pattern)`: Append a pattern to the end (Also aliased to `then`)

`end_with(pattern)`: The line must end with the specified pattern

`maybe(pattern)`: Zero or one of the specified pattern

`not(pattern)`: Specify a negative lookahead, i.e. something not followed by the specified pattern

`one_of(values)`: Specify an alternation, e.g. `one_of(['a', 'b', 'c'])`

`between(range, pattern)`: Specify a bounded repetition, e.g. `between([2,4], :digits)`

`zero_or_more(pattern)`: Specify that the pattern or identifer should appear zero or many times

`one_or_more(pattern)`: Specify that the pattern or identifer should appear one or many times

`at_least(n, pattern)`: Specify that the pattern or identifer should appear n or more times

`at_most(n, pattern)`: Specify that the pattern or identifer should appear n or less times

The DSL methods are chainable, meaning they return `self`. You can also call `regex` on a Regularity object to
return a RegExp object created from the specified pattern.

### Status
[![Build Status](https://travis-ci.org/andrewberls/regularity.png)](https://travis-ci.org/andrewberls/regularity)
