#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Constant'
require 'rexml/document'
include REXML


class Queries
	def initialize()
		@queries = {}
		@request_compute = {}
		path = File.dirname(__FILE__) + "/../Queries/queries.xml"
		
		# Calcul des paires qureies --> paths
		File.open(path) do |file|
			doc = Document.new(file)
			root = doc.root
			root.elements.each("//query") do |t|
				@queries[t.elements["text"].text.strip] = File.dirname(__FILE__) + "/../qrels/qrel" + t.attributes["id"].to_s.sub("q", "") + ".txt"
			end #each
		end #open
	end #initialize
	
	def get_qrel(query)
		path = @queries[query.strip]
		
		# Si la requête existe
		if path != nil
			# Si on a pas encore calculé les qrel pour cette requête
			if @request_compute[path] == nil
				qrels = []
				File.open(path) do |file|
					file.each_line do |line|
						tab_line = line.split
						# cas ou la ligne est cohérente
						if tab_line[2] == "1"
							path_file = tab_line[0]
							xpath = tab_line[1]
							qrels << Struct::Qrel.new(path_file, xpath)
						end #if
					end #each
				end #open
				@request_compute[path] = qrels # On garde en mémoire pour ne pas avoir à le re-calculer
			end #if
			return @request_compute[path]
		end #if
		
		return [] #Si on n'a pas de qrel
	end #get_number_query
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	query = Queries.new
	p query.get_qrel(" balade montagne amérique latine ")
	p query.get_qrel(" balade montagne amérique latine ")
	p query.get_qrel(" balade montagne amérique latfrezfine ")
end #if
