require File.dirname(__FILE__) + '/Graph.rb'
require File.dirname(__FILE__) + '/Deserialization.rb'
require File.dirname(__FILE__) + '/QuestSTA.rb'

class GlobalEval
  attr_accessor :answer
  attr_accessor :statics
  def output(name)
    file = File.open(name, "a+")
    if @answer == nil
      file.write "Execute run() before output !!!!"
      file.close()
      return
    end
    file.write("\n========================== Nodes ==========================\n")
    @answer[2].each_with_index do |item, index|
      file.write("  Node #{index + 1}\n  Voltage = \n")
      item.value.each_pair {|key, value| file.write("    [#{key} Hz] #{value}\n") }
    end
    file.write("======================== Branches =========================\n")
    for i in 0...@answer[0].size
      branch = $global_graph.branches[i]
      file.write("  Branch #{i} [#{branch.from} => #{branch.to}]\n")
      answer[0][i].value.each_key { | key | file.write("    [#{key} Hz] Currency = #{answer[0][i][key]}  Voltage = #{answer[1][i][key]}\n") }
      end
    if @statics != nil and @statics != {}
      file.write("========================= Statics =========================\n")
      @statics.each_pair { |key, value| file.write(" Static<#{key}> => #{eval(value)}\n") }
    end
    file.write("=========================== End ===========================\n")
    file.close()
  end

  def make(description)
    $global_graph = Deserialization.spice(description)
    @answer = nil
  end

  def change(str)
    parts = str.split(':')
    id = parts[0].to_i
    return if id < 0 or id >= $global_graph.branches.count
    params = parts[1].split ','
    params.each {|param| param.strip!}
    typed_change id, params[0], params[1].to_i, params[2].to_i
  end

  def typed_change(branch_id, type, param1, param2)
    $global_graph.branches[branch_id].tag = Deserialization.names(type, [param1, param2])
  end

  def run
    @answer = Elec.QuestAllFrequency($global_graph).dup
  end

  def static(name, sth)
    @statics = {} if @statics.nil?
    @statics[name] = sth
  end
end

$global_eval = GlobalEval.new
$global_graph = Graph.new(0)
