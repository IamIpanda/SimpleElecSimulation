require File.dirname(__FILE__) + '/MatrixFix.rb'
require File.dirname(__FILE__) + '/Branch.rb'
require File.dirname(__FILE__) + '/Node.rb'

class Graph

  # @param [Graph] graph
  # @return [Matrix]
  def self.GenerateMatrixAFromBranches(graph)
    answer = Matrix.zero graph.nodes.count, graph.branches.count
    graph.branches.each_with_index do |branch, index|
      answer[branch.from, index] = 1
      answer[branch.to, index] = -1
    end
    answer
  end

  def self.GenratePassedMatrixAFromBranches(graph)
    answer = Matrix.zero graph.nodes.count - 1, graph.branches.count
    graph.branches.each_with_index do |branch, index|
      answer[branch.from - 1, index] = 1 if branch.from != 0
      answer[branch.to - 1, index] = -1 if branch.to != 0
    end
    answer
  end

  # @param [Graph] graph
  # @param [Matrix] matrix
  # @return [Array]
  def self.GenerateBranchesFromMatrixA(graph, matrix)
    branches = []
    for j in 0...matrix.column_count
      from = nil
      to = nil
      for i in 0...matrix.row_count
        from = i if matrix[i, j] == 1
        to = i if matrix[i, j] == -1
      end
      branches.push graph.GenerateActualBranch(from, to) if !from.nil? and !to.nil?
    end
    branches
  end

  def GenerateNodes(size)
    return (0...size).collect do |id|
      Node.new self, id
    end
  end

  def GenerateActualBranch(from ,to)
    return Branch.new self, @branches.size, from, to, nil
  end

  def GenerateBranch(from, to)
    self.branches.push GenerateActualBranch from, to
  end

  # @param [int] id
  # @return [Node]
  def NodeFor(id)
    while @nodes.count <= id
      @nodes.push Node.new self, @nodes.count
    end
    return @nodes[id + 1]
  end

  def dup
    graph = Graph.new(0)
    graph.branches = self.branches.collect { |branch| branch.dup }
    graph.nodes = self.nodes.collect { |node| node.dup }
    return graph
  end
end