module RefinedString
  refine String do
    def foobar
      'foobar'
    end
  end
end

module RefinedSymbol
  refine Symbol do
    def foobar
      'foobar'
    end
  end
end


activate RefinedString
