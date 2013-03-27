#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Queries'
require 'CompareQrel'
require '../Ontologie/Sparqler'
require '../Ontologie/Constant'

class SearchEngine
	def initialize()
		Struct.new("ComparedQrel", :rappel, :precision)
		Struct.new("Term", :id, :term, :label)
		
		@sparqler = Sparqler.new
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
		
		#on compage les qrels si besoin
		if qrels.count > 0
			comparedQrel = compare_qrel.compare(qrels, paragraphes)
		else
			comparedQrel = Struct::ComparedQrel.new(0, 0)
		end #if
		
		# compute time
		end_time = Time.now
		time_compute = end_time - begin_time
		
		return {Request: phrase.strip, Results: paragraphes, Precision: comparedQrel["rappel"], Rappel: comparedQrel["precision"], Ontologie: with_ontology, TimeCompute: time_compute}
	end #search
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	search_engine = SearchEngine.new
	search_engine.search("monuments Afrique", 100, false)
	
=begin	
  sparqler = Sparqler.new
  results = sparqler.get_synonymes("montagne")
  results.each { |result| puts result + "\n" }
  puts "\n"

  results = sparqler.get_children("montagne")
  results.each { |result| puts result + "\n" }
  puts "\n"

  results = sparqler.get_instances("montagne")
  results.each { |result| puts result + "\n" }
  puts "\n"
=end
end #if
