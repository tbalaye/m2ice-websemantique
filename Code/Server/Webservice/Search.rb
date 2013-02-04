require 'rubygems'
require 'sinatra'

get '/search/:label' do
	label = params[:label]
	
	if label.nil?
		status 404
	else
		status 200
		p label.split(" ") * "\n"
	end #if
end #get '/search/:label'
