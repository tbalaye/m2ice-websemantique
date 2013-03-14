#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'


class SearchEngine
	def initialize()
		@connector = Connector.new
	end #initialize
	
	def search(phrase, limite)
		terms = []
		phrase.split.each do |word|
			terms << @connector.get_term(word.downcase)
		end #each
		
		paragraphes = @connector.get_paragraphs(terms, limite)
		p paragraphes
	end #search
	
	def search_with_ontologie()
	
	end #search_with_ontologie
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	search_engine = SearchEngine.new
	search_engine.search("montagne plaine", 2)
	puts "ok"
end #if
