require 'minitest/autorun'
require 'minitest/reporters'
require 'refinements_file'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
