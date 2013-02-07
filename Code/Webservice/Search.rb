require 'rubygems'
require 'sinatra'
require 'json'


def foo(request)
	return {Request: request, Results: [{Xpath:"/doc[2]/sec[1]/p[1]", Content:"J'aime la montagne"},{Xpath:"/doc[2]/sec[1]/p[2]", Content:"La montagne est ton amis"},{Xpath:"/doc[3}/sec[2]/p[3]", Content:"La marmotte aime la montagne"}], Precision: "0.3", Rappel: "0.7"}.to_json
end #foo

get '/search/:request' do
	request = params[:request]
	
	if request.nil?
		status 404
	else
		status 200
		
		return foo(request)
	end #if
end #get '/search/:label'
