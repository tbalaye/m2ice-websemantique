#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Queries'

class SearchEngine
	def initialize()
		@connector = Connector.new
		@queries = Queries.new()
	end #initialize
	
	def search(phrase, limite)
		terms = []
		phrase.split.each do |word|
			terms << @connector.get_term(word.downcase)
		end #each
		
		paragraphes = @connector.get_paragraphs(terms, limite)
		qrels = @queries.get_qrel(phrase)
		
		return paragraphes
	end #search
	
	def search_with_ontologie()
	
	end #search_with_ontologie
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	search_engine = SearchEngine.new
	p search_engine.search(" balade montagne amérique latine ", 10)
end #if
