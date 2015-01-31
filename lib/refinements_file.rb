require "refinements_file/no_monkey_patch"

module Kernel
  private

  # @see RefinementsFile.refinement
  def refinement(file_name)
    RefinementsFile.refinement(file_name)
  end
end
