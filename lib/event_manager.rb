puts "Event Manager Initialized!"

Dir.chdir("..")
lines = File.readlines("event_attendees.csv")
lines.each_with_index do |line,index| 
	next if index == 0
	columns = line.split(',')
	names = columns[2]
	puts names
end
