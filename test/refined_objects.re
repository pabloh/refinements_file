module R1
  refine Array do
    def bazbaz
      'bazbaz'
    end
  end
end

module R2
  refine Symbol do
    def bazbaz
      'bazbaz'
    end
  end
end


activate R1
activate R2
