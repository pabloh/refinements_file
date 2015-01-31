module RefinedString
  refine String do
    def foobar
      'foobar'
    end
  end
end

activate RefinedString
activate 'not a module'
