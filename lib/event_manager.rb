require "csv"
require "sunlight/congress"
require 'erb'
require 'date'

Sunlight::Congress.api_key = "8c7a9be6703a42f296f40a3aebeeba5f"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

def clean_phone_number(phone_number)
	phone_number.gsub!(/\D/,'')
	if phone_number.length < 10
		phone_number = phone_number.ljust(10,"0")
	elsif phone_number.length == 11 && phone_number.start_with?("1")
		phone_number = phone_number[1,10]
	else
		phone_number = phone_number[0,10]
	end
	phone_number = "#{phone_number[0,3]}-#{phone_number[3,3]}-#{phone_number[6,4]}"
	phone_number
end

def count_frequency(arr,item_to_count)
	arr.sort!
	frequency = {}
	arr.each do |i|
		key = "#{item_to_count}_#{i}".to_sym
		frequency[key] = arr.count(i)
	end
	frequency
end

def split_time(date_array)
	time = {}
	hours = []; minutes = []; days = []; months = []; years = [];	wday = []
	date_array.each do |date|
		hours << date.hour;	minutes << date.minute;	days << date.day;	months << date.month;	years << date.year;	wday << date.wday
	end
	time[:hours] = hours;	time[:minutes] = minutes;	time[:days] = days;	time[:months] = months;	time[:years] = years; time[:wday] = wday
	time
end

puts "Event Manager Initialized!"
file_path = File.join('C:','users', 'macivor', 'desktop', 'the odin project', 'event_manager', 'event_attendees.csv')
contents = CSV.open(file_path, headers: true, header_converters: :symbol)

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter
date_array = []

contents.each do |row|
	id = row[0]
  name = row[:first_name]
	rawdate = row[:regdate].gsub('/','-')	
	date_array << DateTime.strptime(rawdate, '%m-%d-%Y %H:%M')	
	
  zipcode = clean_zipcode(row[:zipcode])

  #legislators = legislators_by_zipcode(zipcode)

  #form_letter = erb_template.result(binding)
	
	#save_thank_you_letters(id,form_letter)
	phone_number = clean_phone_number(row[:homephone])
	#puts phone_number
end

time_hash = split_time(date_array)

time_hash.each do |key,value|	
	frequency = count_frequency(value, "#{key.to_s}")
	puts frequency
end



