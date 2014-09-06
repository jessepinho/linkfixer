module ApplicationHelper

	require 'net/http'
	require 'csv'

	def find_http_response(filename)

		url = Array.new
		csv_output = Array.new

		CSV.foreach(filename, :headers => false) do |row|
  			url << row
		end

		url.each do |x|

			last_col = x[x.length - 1].to_s

			begin

				uri = URI(last_col)
				res = Net::HTTP.get_response(uri)
				csv_output << [*x, res.code, res.message]

				sleep 1

			rescue

				csv_output << [*x, "", "Couldn't ping"]
				next

			end

		end

		CSV.open("/Users/jaypinho/Desktop/fileoutput.csv", "wb") do |csv|
			csv_output.each do |y|
				csv << y
			end
		end

	end

	def testsomething
		testvar = ["hello", "goodbye"]
		testvar2 = [*testvar, "and adieu"]
		puts testvar2.inspect
	end

end
