require 'set'

module Many
  def many?
    self.size > 1
  end
end

module JustOne
  def just_one?
    self.size == 1
  end
end

activate refined(Set, with: Many)
activate refined(Array, with: [Many, JustOne])
