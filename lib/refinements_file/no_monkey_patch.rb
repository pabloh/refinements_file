require "refinements_file/version"

module RefinementsFile
  module DSL
    # Indicates the module passed at the first parameter will be activated for the files using the current definition file.
    #
    # @abstract
    # @param mod [Module] the module to be activated
    def activate(mod)
    end

    # @see RefinementsFile.refined
    def refined(klass, with:)
      ::RefinementsFile.refined(klass, with: with)
    end
  end

  class << self
    def top_level_refinement_for(file_name) # :nodoc:
      Module.new do
        refine TOPLEVEL_BINDING.receiver.singleton_class do
          include DSL

          define_method :activate do |mod|
            ::RefinementsFile.loaded_definitions[file_name] ||= []
            ::RefinementsFile.loaded_definitions[file_name] << mod
          end
        end
      end
    end

    def loaded_definitions # :nodoc:
      @loaded_definitions ||= {}
    end
    
    def file_path_for(file_name) # :nodoc:
      file_name = "#{file_name}.re"

      if path = $:.detect {|path| File.exist?(File.join(path, file_name)) }
        File.join(path, file_name)
      else
        raise LoadError, "Could not load refinement definition file -- #{file_name}"
      end
    end

    def contents_for(file_name) # :nodoc:
      file_path = file_path_for(file_name)
      header_for(file_name) + File.read(file_path)
    end

    def header_for(file_name) # :nodoc:
      "using RefinementsFile.top_level_refinement_for('#{file_name}')\n\n"
    end

    def refinement_module_for(modules) # :nodoc:
      modules.each do |mod|
        unless mod.class == Module
          raise LoadError, "Refinement definition file used type #{mod.class} (expected Module)"
        end
      end

      modules.one? ? modules.first : Module.new { modules.each &method(:include) }
    end

    # Returns a refinement for the class at the first parameter using the modules at the second.
    #
    # @param klass [Class] the class you want to refine
    # @param with [Module, Array<Module>] the modules you want to include in your refinement
    # @return [Module]
    def refined(klass, with:)
      Module.new do
        refine klass do
          Array(with).each &method(:include)
        end
      end
    end

    # Returns a refinement module including all the refinements been used at the definition file passed as parameter.
    #
    # @param file_name [String] the refinments definitions file to load (it mustn't the include extension)
    # @return [Module]
    def refinement(file_name) # :nodoc:
      loaded_definitions[file_name] ||= begin
        TOPLEVEL_BINDING.eval(contents_for(file_name))
        refinement_module_for(loaded_definitions[file_name])
      end
    end
  end
end
