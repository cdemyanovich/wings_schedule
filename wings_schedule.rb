require 'hpricot'
require 'open-uri'
require 'icalendar'

calendar = Icalendar::Calendar.new

schedule = Hpricot(open("http://redwings.nhl.com/team/app?service=page&page=SubseasonSchedule"))

games = schedule.search('tr.oddRowColor | tr.evenRowColor')
games.each do |game|
  raw_details = game.children_of_type('td')
  details = raw_details.map { |d| d.inner_text.to_s.strip }
  # details.each_with_index { |d, i| puts "[#{i}] = #{d}" }
  event = Icalendar::Event.new
  event.summary = "#{details[1]} @ #{details[2]}"
  event.dtstart = DateTime.parse("#{details[0]} at #{details[5]}")
  event.duration = "PT3H" # 3 hours
    
  calendar.add_event(event)
end

File.open('red_wings_2008_09.ics', 'w') do |file|
  file.puts calendar.to_ical
end