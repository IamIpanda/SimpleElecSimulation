require File.dirname(__FILE__) + '/GraphHelp.rb'
require File.dirname(__FILE__) + '/Node.rb'
require File.dirname(__FILE__) + '/Branch.rb'

class Graph
  # 顶点集合
  attr_accessor :nodes

  # 边集合
  attr_accessor :branches

  def initialize(node_count)
    @nodes = GenerateNodes node_count + 1
    @branches = []
  end


  @A = nil
  # 求关联矩阵
  # @return [Matrix]
  def MatrixA
    return @A.nil? ? GenerateMatrixA() : @A
  end

  def MatrixSpecialA
    return Graph.GenratePassedMatrixAFromBranches(self)
  end

  def GenerateMatrixA
    return @A = Graph.GenerateMatrixAFromBranches(self)
  end

  # 求回路矩阵
  # @return [Matrix]
  def MatrixB
    return nil
  end

  # 求割补矩阵
  # @return [Matrix]
  def MatrixQ
    return nil
  end
end
