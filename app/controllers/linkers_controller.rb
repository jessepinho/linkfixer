class LinkersController < ApplicationController

	include ApplicationHelper

	def index

	    respond_to do |format|
	      format.html do
	      end
	      format.csv do
	        send_data(@@post, :type => 'text/csv')
	      end
    end

	end

	def uploader
	    
	  	@@post = find_http_response(params[:CSVfile].tempfile)
	    redirect_to action: "index", :format => :csv
  	end

end
