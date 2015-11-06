module ApplicationHelper

	require 'net/http'
	require 'csv'

	# This method gets the HTTP response information
	def find_http_response(filename, search_term)

		url = Array.new
		csv_output = Array.new

		# Pass the contents of the CSV file into an array
		CSV.foreach(filename, :headers => false) do |row|
  			url << row
  			# Enforce row limit of 50
  			break if url.length == 50
		end

		# Parse through each row
		url.each do |x|

			# Select the last (right-most) field of each row
			last_col = x[x.length - 1].to_s

			begin

				uri = URI(last_col)
				res = Net::HTTP.get_response(uri)

				case res
				when Net::HTTPRedirection
					# If redirected, find the final destination URL
					final_redir = get_final_redirect(res['location'])
					if search_term != ""
						csv_output << [*x, res.code, res.message, final_redir, res.body.include?(search_term).to_s]
					else
						csv_output << [*x, res.code, res.message, final_redir, ""]
					end
				else
					if search_term != ""
						csv_output << [*x, res.code, res.message, "", res.body.include?(search_term).to_s]
					else
						csv_output << [*x, res.code, res.message, "", ""]
					end
				end

				# Un-comment the below "sleep" method in order to enable a 1-second pause between pings
				# sleep 1

			# In case of error...
			rescue

				csv_output << [*x, "", "Couldn't ping", ""]
				next

			end

		end

		# Create the final CSV output file
		csv_outcome = CSV.generate("") do |csv|
			csv_output.each do |cf|
				csv << cf
			end
		end

		return csv_outcome

	end

	# This method gets the final redirect of a given URL, up to a maximum of 5 successive redirects (which can be changed to any other number)
	def get_final_redirect(page_url, limit = 5)

		raise ArgumentError, 'Too many HTTP redirects' if limit == 0

		begin

			res = Net::HTTP.get_response(URI(page_url))

			case res
			when Net::HTTPRedirection
				# Recursively calls the same method until we hit a non-redirected URL or reach 5 redirects
				get_final_redirect(res['location'], limit - 1)
			else
				page_url
			end

			# sleep 1

		rescue

			page_url

		end
	end

end
