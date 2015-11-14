Node = Struct.new :owner, :id

class Node
  def inspect
    return "[#{self.id}]"
  end
end