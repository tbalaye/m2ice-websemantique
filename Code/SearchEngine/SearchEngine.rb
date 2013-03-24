#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Queries'
require 'CompareQrel'

class SearchEngine
	def initialize()
		@connector = Connector.new
		@queries = Queries.new()
	end #initialize
	
	def search(phrase, limite, with_ontology)
		terms = []
		compare_qrel = CompareQrel.new()
		paragraphes = nil
		begin_time = Time.new # initiate time
		
		phrase.split.each do |word|
			term = @connector.get_term(word.downcase)
			terms << term if not term == nil
		end #each
		
		paragraphes = @connector.get_paragraphs(terms, limite) if terms.count > 0
		qrels = @queries.get_qrel(phrase)
		comparedQrel = compare_qrel.compare(qrels)
		
		# compute time
		end_time = Time.now
		time_compute = end_time - begin_time
		
		return {Request: phrase.strip, Results: paragraphes, Precision: comparedQrel["rappel"], Rappel: comparedQrel["precision"], Ontologie: with_ontology, TimeCompute: time_compute}
	end #search
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	search_engine = SearchEngine.new
	p search_engine.search(" balade montagne amérique latine ", 10, false)
end #if
