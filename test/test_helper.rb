require 'minitest/autorun'
require 'minitest/reporters' # requires the gem
require 'pry'
require 'refinements_file'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
