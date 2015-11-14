Branch = Struct.new :owner, :id, :from, :to, :tag

class Branch
  def inspect
    return "[#{self.from} -> #{self.to}]"
  end

  alias base_dup dup
  def dup
    ans = base_dup()
    ans.tag = self.tag.dup
    return ans
  end
end