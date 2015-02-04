# RefinementsFile
[![Build Status](https://travis-ci.org/pabloh/refinements_file.svg?branch=master)](https://travis-ci.org/pabloh/refinements_file)

RefinementsFile is a gem that enriches Ruby with refinement definition files allowing to easily reuse the same refinements across multiple files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'refinements_file'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install refinements_file

## Usage

The first thing you need is a refinement definition file, which is simply a ruby source file with the extension '.re'.
The a special extension '.re' is used in order to avoid accidentally loading the definition file using `require` which would entail a different behavior.
Inside that file you must define which refinements you want activated using the `activate` keyword (keep in mind the refinements referenced here will only be activated at the files loading the definitions but not within the definition file itself).

So for instance a refinement definition file could be something like this:

```ruby
# my_definitions.re

require 'foobar'
activate FooBarRefinement
```

You must place the defintion file at some point at the `$LOAD_PATH` otherwise it won't be found.

Finally, to activate the definitions from a regular ruby source file, use the `refinement` method to bring in the refinements and give the result to the `using` keyword like this:

```ruby
# my_file.rb

using refinement('my_definitions')
```

Every file required and any other kind of definitions (like classes or modules) from `'my_definitions.re'` will also be available.

### Remove Kernel module monkey patching

As you have probably already realized, this gem will define a top level method `refinement`, at the Kernel module, in order the retrieve the definition files (`activate` is not really available outside defintion files). If you would rather keep your environment completely pristine, and leave the Kernel module alone, you can requiere from `'refinements_file/no_monkey_patch'` in lieu of `'refinements_file'` and then use `RefinementsFile.refinement('my_definitions')` instead.


### Example: MiniTest::Spec

Suppose you want to use the Minitest expectations syntax at every file on your test suite, and obviously, you would rather avoid monkey patching the code you intend to test.

First let's asume we start with a `'test_helper.rb'` file like this one:

```ruby
require 'minitest/autorun'
require 'minitest/reporters'
require 'my_awesome_gem'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
```

Since Minitest itself doesn't provide any refinement module yet (and, as of now, neither does almost any other gem out there), you would need to define a new module that refines the Object class with the Minitest expectations methods, and then, make it available at the definition file. For instance you could do the following:

```ruby
require 'test_helper'

module ObjectWithExpectations
  refine Object do
    include Minitest::Expectations
  end
end

activate ObjectWithExpectations
```

Since this is likely to be a common pattern, RefinementsFile provides a shortcut for these cases with the helper method `refined`. Using this method the above code becomes:

```ruby
require 'test_helper'
activate refined(Object, with: Minitest::Expectations)
```

Mind you, if you need more than one module, the `with` parameter also will take an Array of modules.

Also since Minitest will monkey patch Object as soon as you require `'minitest/autorun'`, you need to set the environment variable `MT_NO_EXPECTATIONS` first to prevent it. So, summing up our definition file, let's name it `'refined_specs.re'`, would look something like this:

```ruby
# refined_specs.re

ENV["MT_NO_EXPECTATIONS"] = 'true'
require 'test_helper'
activate refined(Object, with: Minitest::Expectations)
```

Then, modify the TestTask configuration at your Rakefile, so the refinements_file gem will be already loaded when you run your tests:

```ruby
# Rakefile

require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << %w(test lib)
  task.pattern = 'test/test_*.rb'
  task.ruby_opts << '-r refinement_file' # Add this line
end
```

With all that in place you could write your tests like this:

```ruby
# test_my_awesome_object.rb

using refinement('refined_specs')

describe MyAwesomeObject do
  it 'shoud be awesome' do
    MyAwesomeObject.new.must_be :awesome?
  end
end

```

So by adding that simple 3 lines file and a single line at Rakefile, we now have a monkey patching free test suite. (Although we are still polluting the global namespace with `describe` but Minitest doesn't provide a way around that).

## Contributing

1. Fork it ( https://github.com/pabloh/refinements_file/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
