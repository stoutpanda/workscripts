#Script to clean up & help prepare csv export from CCURE 9000 for access.
#Authored on: 12/28/2015
#Updated on: 12/31/2015
#Export journal entries for CCURE 9000 (not a report), and then point this to the CSV file.
#Log on to the security server, open CCURE9000, go to Data Views > Query and hit the green arrow.
#Run the SWHrep13 - Personnel Admitted at Doors in Time Range Query
#Enter your specific paramters, then perform the search. Select all results, right click > export to csv file.
#Delete the header row in a text editor (Notepad, Notepad++, Atom... don't use excel)
#Change input_file to the name of your  file, place in the same directory as this script and run this script.


#csv library
require 'csv'
#date
require 'date'

#Source File:
input_file = 'JournalRaw.csv'
#output File:
output_file = 'JournalRaw_updated.csv'



csv_array = Array.new
edit_array = Array.new
date_array = Array.new
final_array = Array.new
sort_array = Array.new
group_array = Array.new
value_array = Array.new


#find date / time.
def find_date(dtime)
	dtime = DateTime.strptime(dtime.gsub(/ /, '_'), "%d/%m/%Y_%I:%M:%S_%P")
  return dtime
end

#Clean name
def find_name(name)
  re_name = Regexp.new(/'(.*?)'/)
  name.match(re_name)[1]
end
#split time and date
def split_dtime (dtime)
  date = dtime.strftime("%m-%d-%Y")
  time = dtime.strftime("%I:%M %P")
  [date,time]
	end



#read csv and put it into an array of arrays
csv_array = CSV.read(input_file)

#Create a new array with the date and time we need
edit_array = csv_array.map { |row| rowp = [row[3], row[4]] }

#Pull just the name out,  convert date to date time, split into [name, [date,time]].
date_array = edit_array.map do |row_name,row_dtime|
  punchtime = find_date(row_dtime)
  punchtime = split_dtime(punchtime)
  eename = find_name(row_name)
  [eename,punchtime].flatten
end



#Sort by name, date, time
sort_array = date_array.sort_by { |n,d,t| [n,[d,t]] }

#Still need to do min, max and group time for each date. 



CSV.open(output_file, "wb") do |csvfile|
 	sort_array.each do |row|
	  csvfile << row


 	end
end
