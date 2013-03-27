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
		Struct.new("Term", :id, :term, :label, :weight)
		
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
			word_downcase = word.downcase
			
			simple_term = @connector.get_term(word_downcase, SIMPLE_TERM_WEIGHT)
			
			# on ajoute les termes dans les termes recherché avec un poids de mot simple
			terms << simple_term if not simple_term == nil
			
			# Si on utilise l'ontologie, on ajoute les termes retourné par sparqler (si il en existe)
			if with_ontology
				synonymes = @sparqler.get_synonymes(word_downcase)
				children = @sparqler.get_children(word_downcase)
				instances = @sparqler.get_instances(word_downcase)
			
				# On ajoute les termes de l'ontologies dans les termes recherché avec les poids correspondant à leur status
				compute_ontology(synonymes, terms, SYNONYME_TERM_WEIGHT)
				compute_ontology(children, terms, CHILD_TERM_WEIGHT)
				compute_ontology(instances, terms, INSTANCE_TERM_WEIGHT)
			end
		end #each
		
		paragraphes = @connector.get_paragraphs(terms, limite) if terms.count > 0
		qrels = @queries.get_qrel(phrase)
		
		#on compage les qrels si besoin
		if qrels.count > 0
			comparedQrel = compare_qrel.compare(qrels, paragraphes)
		else
			comparedQrel = Struct::ComparedQrel.new(-1, -1)
		end #if
		
		# compute time
		end_time = Time.now
		time_compute = end_time - begin_time
		
		return {Request: phrase.strip, Results: paragraphes, Precision: comparedQrel["rappel"], Rappel: comparedQrel["precision"], Ontologie: with_ontology, TimeCompute: time_compute}
	end #search
	
	
	private
	
	def compute_ontology(words_tab, terms, weight)
		words_tab.each do |words|
			words.split.each do |word|
				simple_term = @connector.get_term(word.downcase, weight)
				terms << simple_term if not simple_term == nil
			end #each
		end #each
	end #def
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	search_engine = SearchEngine.new
	search_engine.search("paysage montagne", 100, true)
	
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
