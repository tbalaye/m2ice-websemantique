#coding : utf-8

$LOAD_PATH << File.dirname(__FILE__)


require 'sparql/client'
require 'Constant'

class Sparqler
	attr_reader :client

	def initialize
		@client = SPARQL::Client.new("http://" + URL_ONTOLOGIE + ":" + PORT_ONTOLOGIE + "/balades/query")
	end
  
  def get_synonymes(term)
    request = "SELECT ?title WHERE { ?subject rdfs:label ?title; rdfs:label \"" + term + "@fr\" }"
    return query(request)
  end
  
  def get_children(term)
    request = "
    SELECT ?label WHERE {
      ?s rdfs:label ?titre; rdfs:label \"" + term + "\"@fr.
      ?child rdfs:subClassOf ?s.
      ?child rdfs:label ?label.
    }"
    return query(request)
  end
  
  def get_instances(term)
    request = "
    SELECT ?parent WHERE {
      ?instance rdf:type ?type;
        rdfs:label ?parent.
      ?type rdfs:subClassOf ?class.
      ?class rdfs:label ?label.
      FILTER (?label != ?parent && regex(?label, \"" + term + "\", \"i\"))
    }"
    return query(request)
  end
  
  def query(request)
    query = self.client.query("
      PREFIX :        <http://ontologies.alwaysdata.net/space#>
      PREFIX rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
      PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX owl:      <http://www.w3.org/2002/07/owl#>
      PREFIX xsd:      <http://www.w3.org/2001/XMLSchema#>
      PREFIX bal:     <http://www.semanticweb.org/ontologies/2011/11/Balade#>
    " + request)
    result = []
    query.each_solution do |solution|
      result << solution.inspect.force_encoding("ASCII-8BIT")[/(?<=\")(.*)(?=\")/]
    end
    return result
  end
end

if __FILE__ == $0
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
end