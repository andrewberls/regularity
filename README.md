```
  Regularity.new
   .start_with(4, :characters)
   .then(2, :digits)
   .then(1, :character)
   .then('$')
   .maybe(1, '@')
   .maybe(1, :space)
   .one_of(['hi', 'hello'])
   .between([1,3], :digits)
   .end_with('#')
```
