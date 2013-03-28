#!/usr//bin/ruby1.9.1
#encoding: UTF-8

$LOAD_PATH << File.dirname(__FILE__)

require 'rubygems'
require 'sinatra'
require 'json'

require 'Constant'
require '../SearchEngine/SearchEngine'
require '../SearchEngine/Constant'

set :port, PORT


def compute(request, is_with_ontologie)
	if request.nil?
		status 404
	else
		status 200
		search_engine = SearchEngine.new
		return search_engine.search(request, MAX_RESULT, is_with_ontologie).to_json
	end #if
end #compute

get '/Search/:request' do
	return compute(params[:request], false)
end #get '/search/:label'

get '/SearchOntologie/:request' do
	return compute(params[:request], true)
end #get '/search/:label'
