require File.dirname(__FILE__) + '/Graph.rb'
require File.dirname(__FILE__) + '/GraphHelp.rb'
require File.dirname(__FILE__) + '/electronic_units.rb'

module Deserialization

  # @return [Graph]
  # @param [string] filename
  def self.load_text(filename)
    content = File.open(filename, 'r') { |f| f.read }
    return self.spice content
  end

  # @return [Graph]
  # @param [string] text
  def self.spice(text)
    answer = Graph.new(0)
    lines = text.split /\n/
    lines.each { |line| line.strip! }
    lines = lines.delete_if {|line| line.nil? or line == "" or line.start_with?('#')}
    for line in lines
      parts = line.split ','
      parts.each { |part| part.strip! }
      from = parts[0].to_i
      to = parts[1].to_i
      item = self.names parts[2], parts[3..-1]
      answer.NodeFor(from)
      answer.NodeFor(to)
      answer.branches.push Branch.new(answer, answer.branches.count + 1, from, to, item)
    end
    return answer
  end


  def self.names(name, *args)
    args = args[0]
    if name == "R"
      return ElectricResistance.new(*args)
    elsif name == "C"
      return ElectricCapacity.new(*args)
    elsif name == "L"
      return ElectricInductor.new(*args)
    elsif name == "U"
      return ElectricDirectCurrentVoltageSource.new(*args)
    elsif name == "I"
      return ElectricDirectCurrentCurrentSource.new(*args)
    elsif name == "Ua"
      return ElectricAlternateringCurrentVoltageSource.new(*args)
    elsif name == "Ia"
      return ElectricAlternateringCurrentVoltageSource.new(*args)
    end
  end
end