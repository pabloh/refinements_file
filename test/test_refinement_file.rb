require 'test_helper'

using refinement('refined_objects')
using refinement('refined_string')
using refinement('refined_collections')

class TestRefinementFile < Minitest::Test
  def setup
    @set = Set[]
    @array = []
  end

  def test_explicitly_used_refinements_must_be_loaded
    assert_equal 'foobar', 'a string'.foobar
  end

  def test_defined_but_no_explicitly_used_refinements_must_not_be_loaded
    assert_raises(NoMethodError) { :a_symbol.foobar }
  end

  def test_multiple_explicitly_used_refinements_must_be_loaded
    assert_equal 'bazbaz', :a_symbol.bazbaz
    assert_equal 'bazbaz', [].bazbaz
  end

  def test_invoking_refinement_for_the_same_file_twice_returns_the_same_module
    ref = refinement('misc_refinements')
    assert ref.equal?(refinement('misc_refinements'))
  end

  def test_invoking_refinement_for_an_unexisting_file_raises_a_load_error
    e = assert_raises(LoadError) { refinement('unexistent_def_file') }
    assert_equal 'Could not load refinement definition file -- unexistent_def_file.re', e.message
  end

  def test_invoking_refinement_for_files_that_tries_using_something_different_than_a_module_raises_a_load_error
    e = assert_raises(LoadError) { refinement('invalid_def_file') }
    assert_equal 'Refinement definition file used type String (expected Module)', e.message
  end

  def test_invoking_refinement_using_a_class_and_a_module_returns_a_refinement_for_the_class_using_that_module
    assert_equal false, @set.many?
    assert_raises(NoMethodError) { @set.just_one? }
  end

  def test_invoking_refinement_using_a_class_and_an_array_of_modules_returns_a_refinement_for_the_class_using_those_modules
    assert_equal false, @array.many?
    assert_equal false, @array.just_one?
  end
end
