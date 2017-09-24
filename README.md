# RSAT

* https://github.com/tenderlove/rsat

## DESCRIPTION:

Pure Ruby SAT solver.  Based on simple-sat in Python.

## SYNOPSIS:

Say "A" depends on "B" and "C".  We can encode it as a SAT problem like this:

```
A
~A B
~A C
```

In other words, this problem depends on "A" and "not A or B" and "not A or C".
You can add the problem to the SAT solver and solve it as follows:

```ruby
s = RSAT.new
s.parse_and_add_clause "A"
s.parse_and_add_clause "~A B"
s.parse_and_add_clause "~A C"

s.each_solution do |assignment|
  p :solution => assignment
end
```

## LICENSE:

(The MIT License)

Copyright (c) 2017 Aaron Patterson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
