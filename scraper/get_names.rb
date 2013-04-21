require 'nokogiri'
require 'open-uri'
require 'json'
require 'debugger'

$list = {}

begin
  
  #Uncomment to get all targets
  # p 'Opening FULL JPL NHAT list'
  # uri = "http://neo.jpl.nasa.gov/cgi-bin/nhats?dv=12&dur=360&stay=8&launch=2015-2040&H=26&occ=7&sort=n_via_traj&sdir=DESC&action=Display+Table#top"
  # output_file_name = 'all_nhats'

  #Uncomment to get top targets
  p 'Opening top targets in JPL NHAT list'
  output_file_name = 'targets'
  uri = "http://neo.jpl.nasa.gov/cgi-bin/nhats?dv=6;dur=360;stay=8;launch=2025-2030;H=30;occ=7;sort=H;sdir=ASC;action=Display%20Table;show_inst=0#top"
  
  doc = Nokogiri::HTML(open(uri))
  rows = doc.css('#nhats_table tr')
  rows[1..rows.length].each do |row|
    cols = row.css('td')
    name = cols[0].text.strip.gsub(/[\(\)]/, "")
    href = cols[0].css('a')[0]['href']
    $list[name] = {
      :name => name,
      :H => cols[2].text.to_f,
      :dia => cols[3].text,
      :mindV => {
        :dV => cols[5].text.scan(/([0-9\.]+)/)[0][0].to_f,
        :days => cols[5].text.scan(/([0-9\.]+)/)[1][0].to_i
      },
      :minDur => {
        :dV => cols[6].text.scan(/([0-9\.]+)/)[0][0].to_f,
        :days => cols[6].text.scan(/([0-9\.]+)/)[1][0].to_i
      },
    }
    begin
      p 'opening page for ' + name
      
      page = Nokogiri::HTML(open(URI::encode(href)))
      rows2 = page.css('#traj_table tr')
      $list[name][:mindV][:flight] = {
        :out => rows2[3].css('td')[0].text.to_i,
        :stay => rows2[4].css('td')[0].text.to_i,
        :in => rows2[5].css('td')[0].text.to_i,
        :launch => rows2[6].css('td')[0].text,
        :c3 => rows2[7].css('td')[0].text.to_f
      }
      $list[name][:minDur][:flight] = {
        :out => rows2[3].css('td')[1].text.to_i,
        :stay => rows2[4].css('td')[1].text.to_i,
        :in => rows2[5].css('td')[1].text.to_i,
        :launch => rows2[6].css('td')[1].text,
        :c3 => rows2[7].css('td')[1].text.to_f
      }
    rescue Exception => e
      p e.inspect
      p e.backtrace
    end
  end
rescue Exception => e
  p e.inspect
  p e.backtrace
end

File.open('../json/' + output_file_name + '.json', 'w') do |f|
  f.write($list.to_json)
end
p 'wrote file'
