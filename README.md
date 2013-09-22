## Regularity - Regular expressions for humans

Regularity is a friendly regular expression builder for Ruby. Regular expressions are a powerful way of 
pattern-matching against text, but too often they are 'write once, read never'. After all, who wants to try and deciper

```ruby
/^[[0-9]{3}]-[A-Za-z]{2}#*[a|b]a{2,4}\$$/
```

when you could express it as

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

While taking up a bit more space, Regularity expressions are infinitely more readable than their cryptic counterparts.

### TODO

Add description / usage here
