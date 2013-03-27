#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Queries'


class CompareQrel
	
	def compare(qrels, paragraphes)
		found = 0
		error = 0
		
		puts "il y a " + paragraphes.count.to_s + " paragraphes"
		puts "il y a " + qrels.count.to_s + " qrels"
		
		paragraphes.each do |paragraphe, index|
			if qrels.detect{|qrel| (qrel["path_file"] == paragraphe[:pathFile].sub("../", "")) and (qrel["xpath"] == paragraphe[:xpath])}
				found += 1
			else
				error += 1
			end #if
		end #each
		
		puts "found: " + found.to_s
		puts "error: " + error.to_s
		
		
		return Struct::ComparedQrel.new(1, 1)
	end
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	Struct.new("ComparedQrel", :rappel, :precision)
	
	compare_qrel = CompareQrel.new()
	
	query = Queries.new
	qrel = query.get_qrel(" balade montagne amérique latine ")
	
end #if
