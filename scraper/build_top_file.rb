require 'open-uri'
require 'json'
require 'debugger'

f = File.open('../json/top_template.json', 'r')
orbital_data_results = JSON.parse(f.read)

filename = 'targets_orbital_data'
f = File.open('../json/' + filename + '.json', 'r')
orbital_data = JSON.parse(f.read)

results_array = []

orbital_data.each do |k, v|
  object = []
  next if !v
  object.push v["score"]
  object.push v["saved"]
  object.push v["price"]
  object.push v["profit"]
  object.push v["closeness"]
  object.push v["GM"]
  object.push v["spec_B"]
  object.push v["full_name"]
  object.push v["moid"]
  object.push v["neo"]
  object.push v["pha"]
  object.push v["diameter"]
  object.push v["inexact"]
  object.push v["dv"]
  object.push v["a"]
  object.push v["e"]
  object.push v["q"]
  object.push v["prov_des"]
  object.push v["w"]
  object.push v["i"]
  object.push v["om"]
  object.push v["ma"]
  object.push v["n"]
  object.push v["epoch"]
  object.push v["tp"]
  object.push v["per"]
  object.push v["fuzzed_price"]
  results_array.push object
end

orbital_data_results["results"]["rankings"] = results_array

File.open('../json/' + filename + '_topfile.json', 'w') do |f|
  f.write(orbital_data_results.to_json)
end
p 'wrote file'
