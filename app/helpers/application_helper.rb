module ApplicationHelper

	require 'net/http'
	require 'csv'

	def find_http_response(filename)

		url = Array.new
		csv_output = Array.new

		CSV.foreach(filename, :headers => false) do |row|
  			url << row[0].to_s
		end

		url.each do |x|

			uri = URI(x)
			res = Net::HTTP.get_response(uri)
			csv_output << [x, res.code, res.message]

			sleep 2

		end

		CSV.open("/Users/jaypinho/Desktop/fileoutput.csv", "wb") do |csv|
			csv_output.each do |y|
				csv << y
			end
		end

	end

end
