require 'rubygems'
require 'sinatra'
require 'json'



def foo(request, is_with_ontologie)
	return {Request: request, Results: [{Xpath:"/doc[2]/sec[1]/p[1]", Content:"J'aime la montagne"},{Xpath:"/doc[2]/sec[1]/p[2]", Content:"La montagne est ton amis"},{Xpath:"/doc[3}/sec[2]/p[3]", Content:"La marmotte aime la montagne"}], Precision: "0.3", Rappel: "0.7", Ontologie: is_with_ontologie.to_s, TimeCompute:"1.3"}.to_json
end #foo

def compute(request, is_with_ontologie)
	if request.nil?
		status 404
	else
		status 200	
		return foo(request, is_with_ontologie)
	end #if
end #compute

get '/Search/:request' do
	return compute(params[:request], false)
end #get '/search/:label'

get '/SearchOntologie/:request' do
	return compute(params[:request], true)
end #get '/search/:label'
