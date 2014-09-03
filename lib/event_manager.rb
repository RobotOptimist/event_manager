require "csv"
require "sunlight/congress"
require 'erb'

puts "Event Manager Initialized!"

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

file_path = File.join('C:','users', 'macivor', 'desktop', 'the odin project', 'event_manager', 'event_attendees.csv')
contents = CSV.open(file_path, headers: true, header_converters: :symbol)

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

#contents.each do |row|
	#id = row[0]
  #name = row[:first_name]

  #zipcode = clean_zipcode(row[:zipcode])

  #legislators = legislators_by_zipcode(zipcode)

  #form_letter = erb_template.result(binding)
	
	#save_thank_you_letters(id,form_letter)
#end

contents.each do |row|
	phone_number = row[:homephone]
	phone_number.gsub!(/\D/,'')
	if phone_number.length < 10
		phone_number = phone_number.ljust(10,"0")
	end
	if phone_number.length == 11 && phone_number.start_with?("1")
		phone_number = phone_number[1,10]
	end
	phone_number = phone_number[0,3] + "-" + phone_number[4,4] + "-" + phone_number[6,9]
	puts phone_number
end
