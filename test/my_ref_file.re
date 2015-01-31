module MyRefs
  refine Object do
    def foobar
    end
  end

  refine String do
    def bazbaz
    end
  end
end
