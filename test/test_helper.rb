require 'minitest/autorun'
require 'minitest/reporters' # requires the gem
require 'refinements_file'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
