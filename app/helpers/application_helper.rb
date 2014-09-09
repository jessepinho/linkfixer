module ApplicationHelper

	require 'net/http'
	require 'csv'

	def find_http_response(filename)

		url = Array.new
		csv_output = Array.new

		CSV.foreach(filename, :headers => false) do |row|
  			url << row
  			break if url.length == 50
		end

		url.each do |x|

			last_col = x[x.length - 1].to_s

			begin

				uri = URI(last_col)
				res = Net::HTTP.get_response(uri)

				case res
				when Net::HTTPRedirection
					csv_output << [*x, res.code, res.message, res['location']]
				else
					csv_output << [*x, res.code, res.message, ""]
				end
				
				puts last_col
				# sleep 1

			rescue

				csv_output << [*x, "", "Couldn't ping", ""]
				next

			end

		end

		csv_outcome = CSV.generate("") do |csv|
			csv_output.each do |cf|
				csv << cf
			end
		end

		return csv_outcome

=begin
		output_file = File.dirname(filename).to_s
		unless (output_file.last == "/") or (output_file.last == "\\")
			if output_file.include? "\\"
				output_file += "\\"
			else
				output_file += "/"
			end
		end
		output_file += File.basename(filename).to_s.first(File.basename(filename).to_s.length - 4)
		output_file += "_output.csv"

		CSV.open(output_file, "wb") do |csv|
			csv_output.each do |y|
				csv << y
			end
		end
=end

	end

	def testsomething
		testvar = ["hello", "goodbye"]
		testvar2 = [*testvar, "and adieu"]
		puts testvar2.inspect

		puts File.dirname("/Users/jaypinho/Desktop/fileoutput.csv")
		puts File.basename("/Users/jaypinho/Desktop/fileoutput.csv")

	end

end
