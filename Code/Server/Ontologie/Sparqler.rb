#coding : utf-8

$LOAD_PATH << File.dirname(__FILE__) + "/../"


require 'sparql/client'
require 'Constant'

class Sparqler
	attr_reader :client

	def initialize
		@client = SPARQL::Client.new("http://" + URL_ONTOLOGIE + ":" + PORT_ONTOLOGIE + "/space/query") 
	end
end

sparqler = Sparqler.new

# SELECT * WHERE { ?s ?p ?o } OFFSET 100 LIMIT 10

query = sparqler.client.select.where([:s, :p, :o]).limit(20)

query.prefix(": <http://ontologies.alwaysdata.net/space#>")
query.prefix("rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>")
query.prefix("rdfs: <http://www.w3.org/2000/01/rdf-schema#>")
query.prefix("owl:  <http://www.w3.org/2002/07/owl#>")
query.prefix("xsd:  <http://www.w3.org/2001/XMLSchema#>")

query.each_solution do |solution|
	puts solution.inspect + "\n" *3
end

=begin

PREFIX : <http://ontologies.alwaysdata.net/space#>
PREFIX rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl:  <http://www.w3.org/2002/07/owl#>
PREFIX xsd:  <http://www.w3.org/2001/XMLSchema#>

SELECT *
WHERE {
	  ?subject ?property ?object.
}
LIMIT 20

=end
