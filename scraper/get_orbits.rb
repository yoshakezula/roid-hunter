require 'open-uri'
require 'json'
require 'debugger'

$list = {}

begin
  filename = 'targets'

  f = File.open('../json/' + filename + '.json', 'r')
  data = JSON.parse(f.read)

  p data.length.to_s + ' asteroids being pulled'

  orbital_data = {}

  data.each do |k, v|
    p 'Opening ' + v["name"]
    uri = "http://www.asterank.com/api/asterank?query=%7B%22prov_des%22:%22"  + v["name"].gsub(' ', '%20') + "%22%7D&limit=1"
    orbital_data[v["name"]] = JSON.parse(open(uri).read)[0]
  end
rescue Exception => e
  p e.inspect
  p e.backtrace
end

File.open('../json/' + filename + '_orbital_data.json', 'w') do |f|
  f.write(orbital_data.to_json)
end
p 'wrote file'
