require 'rubygems'
require 'sinatra'
require 'json'

get '/search/:label' do
	label = params[:label]
	
	if label.nil?
		status 404
	else
		status 200
		{method: label, version: "1.00"}.to_json
	end #if
end #get '/search/:label'
