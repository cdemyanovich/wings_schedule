require 'hpricot'
require 'open-uri'

schedule = Hpricot(open("http://redwings.nhl.com/team/app?service=page&page=SubseasonSchedule"))

games = schedule.search('tr.oddRowColor | tr.evenRowColor')
games.each do |game|
  raw_details = game.children_of_type('td')
  details = raw_details.map { |d| d.inner_text.to_s.strip }
  details.each_with_index { |d, i| puts "[#{i}] = #{d}" }
end
