require File.dirname(__FILE__) + '/Graph.rb'
require File.dirname(__FILE__) + '/global_eval.rb'

text = File.open(File.dirname(__FILE__) + '/输入样例/input_example3.txt', 'r') { |f| f.read }
$global_eval.instance_eval(text)