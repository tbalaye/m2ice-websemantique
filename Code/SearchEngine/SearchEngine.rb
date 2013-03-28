#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Queries'
require 'CompareQrel'
require '../Ontologie/Sparqler'
require '../Ontologie/Constant'

class SearchEngine
	def initialize()
		@sparqler = Sparqler.new
		@connector = Connector.new
		@queries = Queries.new()
	end #initialize
	
	def search(phrase, limite, with_ontology)
		terms, terms_simple, terms_synonymes, terms_chidren, terms_instances = [], [], [], [], []
		compare_qrel = CompareQrel.new()
		paragraphes = nil
		name_qrel = ""
		begin_time = Time.new # initiate time
		
		phrase.split.each do |word|
			word_downcase = word.downcase
			
			# on ajoute les termes dans les termes recherché avec un poids de mot simple
			simple_term = @connector.get_term(word_downcase, SIMPLE_TERM_WEIGHT)
			terms_simple << simple_term if not simple_term == nil
			
			# Si on utilise l'ontologie, on ajoute les termes retourné par sparqler (si il en existe)
			if with_ontology
				synonymes = @sparqler.get_synonymes(word_downcase)
				children = @sparqler.get_children(word_downcase)
				instances = @sparqler.get_instances(word_downcase)
			
				# On ajoute les termes de l'ontologies dans les termes recherché avec les poids correspondant à leur status
				terms_synonymes = compute_ontology(synonymes, SYNONYME_TERM_WEIGHT)
				terms_chidren = compute_ontology(children, CHILD_TERM_WEIGHT)
				terms_instances = compute_ontology(instances, INSTANCE_TERM_WEIGHT)
			end
		end #each
		
		# On associe tous les termes
		terms = (terms_simple + terms_synonymes + terms_chidren + terms_instances)
		
		# on calcules les paragraphe si il existe au moins un terme à rechercher
		paragraphes = @connector.get_paragraphs(terms, limite) if terms.count > 0
		
		# On vérifie si il y a une qrel
		qrels = @queries.get_qrel(phrase)
		name_qrel = @queries.get_qrel_name(phrase)
		
		#p qrels
		
		#on compage les qrels si besoin
		if qrels.count > 0
			comparedQrel = compare_qrel.compare(qrels, paragraphes)
		else
			comparedQrel = Struct::ComparedQrel.new(-1, -1)
		end #if
		
		# compute time
		end_time = Time.now
		time_compute = end_time - begin_time
		
		return {
					Request: phrase.strip, Results: paragraphes,
					Precision: comparedQrel["rappel"], Rappel: comparedQrel["precision"],
					NameQrel: name_qrel, Ontologie: with_ontology,
					TermSimple: compute_term_summary(terms_simple), TermSynonymes: compute_term_summary(terms_synonymes),
					TermChildren: compute_term_summary(terms_chidren), TermInstances: compute_term_summary(terms_instances),
					TimeCompute: time_compute
				}
	end #search
	
	
	private
	
	def compute_ontology(words_tab, weight)
		result = []
		
		words_tab.each do |words|
			words.split.each do |word|
				simple_term = @connector.get_term(word.downcase, weight)
				result << simple_term if not simple_term == nil
			end #each
		end #each
		
		return result
	end #def
	
	def compute_term_summary(terms)
		result = []
		terms.each{|t| result << t["label"]}
		
		return result
	end
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	search_engine = SearchEngine.new
	search_engine.search("paysage montagne", 100, false)
	
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
