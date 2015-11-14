require File.dirname(__FILE__) + '/MatrixFix.rb'
require File.dirname(__FILE__) + '/Graph.rb'
require File.dirname(__FILE__) + '/Equals.rb'
require File.dirname(__FILE__) + '/electronic_units.rb'

module Elec
  # @param [Graph] graph
  # @return [Array]
  def Elec.QuestSTA(graph)
    a = graph.MatrixSpecialA
    vector_I = Matrix.column_vector([0] * graph.branches.count)
    vector_U = Matrix.column_vector([0] * graph.nodes.count)
    # R 矩阵
    r = Matrix.diagonal(*([1] * graph.branches.count))
    graph.branches.each_with_index { |item, index| r[index, index] = 0 if item.tag.is_a?(ElectricVoltageSource) }
    # G 矩阵
    g = Matrix.diagonal(*(graph.branches.collect { |branch| -branch.tag.G }))
    # Fs 向量
    fs = Matrix.column_vector(graph.branches.collect {|branch| branch.tag.fs } )
    expression_a = Matrix.mstack([
                  [a,                           Matrix.zero(a.row_count, g.column_count), Matrix.zero(a.row_count, a.row_count)],
                  [Matrix.zero(a.column_count), Matrix.unit(g.row_count),                 -1 * a.transpose],
                  [r,                           g,                                        Matrix.zero(r.row_count, a.row_count)]]
    )
    expression_b = Matrix.vstack(Matrix.zero(a.row_count, 1), Matrix.zero(a.column_count, 1), fs)
    x = Equals.Cramer(expression_a, expression_b)
    vector_I = x[0...graph.branches.count]
    vector_Ub = x[graph.branches.count...graph.branches.count * 2]
    vector_Un = x[(graph.branches.count * 2)..-1]
    return [vector_I, vector_Ub, vector_Un]
  end

  # @param [Graph] graph
  def Elec.QuestAllFrequency(graph)
    answer = []
    (1...(graph.nodes.count + graph.branches.count * 2)).each { |i| answer.push MultiFrequencyValue.new }
    sources = []
    graph.branches.each_with_index { |branch, id| sources.push id if branch.tag.is_a?(ElectricSource) }
    for source in sources
      now = graph.dup
      sources.each do |target|
        next if source == target
        now.branches[target].tag = ElectricShort if now.branches[target].tag.is_a?(ElectricCurrentSource)
        now.branches[target].tag = ElectricOpen if now.branches[target].tag.is_a?(ElectricVoltageSource)
      end
      freq = now.branches[source].tag.frequency
      ElectricUnits.frequency = freq
      now_answer = Elec.QuestSTA(now)
      now_answer = now_answer[0] + now_answer[1] + now_answer[2]
      now_answer.each_with_index { |item, index| answer[index][freq] += item }
    end
    for multi_value in answer
      multi_value.value[0] = 0 if multi_value.value[0] == nil
      for key, value in multi_value.value
        next if key == 0
        next if !value.is_a?(Complex)
        multi_value[0] += value.real
        multi_value[key] = value.imag
      end
    end
    vector_I = answer[0...graph.branches.count]
    vector_Ub = answer[graph.branches.count...graph.branches.count * 2]
    vector_Un = answer[(graph.branches.count * 2)..-1]
    return [vector_I, vector_Ub, vector_Un]
  end
end

class MultiFrequencyValue
  attr_accessor :value
  def initialize
    @value = {}
  end
  def []=(id, value)
    @value[id] = value
  end
  def [](id)
    ans = @value[id]
    return ans.nil? ? 0 : ans
  end
  def inspect
    return @value.inspect
  end
  def to_s
    return @value.to_s
  end
end