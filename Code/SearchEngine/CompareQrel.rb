#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Queries'


class CompareQrel
	def initialize
		Struct.new("ComparedQrel", :rappel, :precision)
	end #initialize
	
	def compare(qrels)
		return Struct::ComparedQrel.new(1, 1)
	end
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	compare_qrel = CompareQrel.new()
	
	query = Queries.new
	qrel = query.get_qrel(" balade montagne amérique latine ")
	
	p compare_qrel.compare(qrel)
	
end #if
