# Bindable Block Challenge

This is a challenge I extracted from my [Bindable Block](https://github.com/JoshCheek/bindable_block) gem.
While going through it, I tried to TDD my way to a solution and failed. Then I tried to just write what
seemed like the correct solution and failed. Then, as I was falling asleep, my brain figured it out so
I woke up and wrote it out, and then fixed all the dumb half-asleep mistakes at Code and Coffee the
next morning.

The actual solution is not difficult, it's just easy to misunderstand the problem.

So I removed the solution and the tests leading up to it, and made it a challenge. There is still an
acceptance test in place that you can use to verify the solution. Solve this however you feel is best,
if you think that just writing a solution for the acceptance test is best, then do that. If you find
the kata-style "tiny little steps" building up to the final solution to be useful, do that. Solve the
problem in whatever way you think is best for solving problems, after trying several
different ways myself, I wanted to see if other people's approaches to problem solving would
allow them to solve it where I couldn't.


# What you need to do

Fill in the ArgAligner class. It will be invoked with a set of arguments and a method
object (you can think of this as a lambda style Proc). The other code needs to invoke the
method object with those arguments, and have it behave like a Proc. I can't do this,
because methods and procs treat their arguments differently:

```ruby
RUBY_VERSION # => "1.9.3"

proc   { |a| a }.call()        # => nil
proc   { |a| a }.call(1, 2, 3) # => 1

lambda { |a| a }.call(1, 2)    # ~> -:4:in `block in <main>': wrong number of arguments (2 for 1) (ArgumentError)
lambda { |a| a }.call()        # ~> -:4:in `block in <main>': wrong number of arguments (0 for 1) (ArgumentError)
```

The ArgAligner class needs to return the set of args to invoke the lambda with,
such that it will behave like the proc. So in the example above, when given `[1, 2]`,
it would return `[1]`, when given `[]`, it would return `[nil]`.

There may be more than one way to solve this, but the way that I thought of is to
reflect on the params, and then match them up with the args list to decide what to return.

```ruby
lambda { |a, b=1, *c, &d| }.parameters # => [[:req, :a], [:opt, :b], [:rest, :c], [:block, :d]]
```


**You do not need to worry about the block param, it is handled separately**
