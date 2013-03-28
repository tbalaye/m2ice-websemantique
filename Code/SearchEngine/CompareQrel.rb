#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Connector'
require 'Queries'


class CompareQrel
	
	def compare(qrels, paragraphes)
		found = 0
		error = 0
		rappel = 0.0
		precision = 0.0
		nb_paragraphes = paragraphes.count
		nb_qrels = qrels.count
		
		puts "il y a " + nb_paragraphes.to_s + " paragraphes"
		puts "il y a " + nb_qrels.to_s + " qrels"
		
		paragraphes.each do |paragraphe, index|
			if qrels.detect{|qrel| (qrel["path_file"] == paragraphe[:pathFile].sub("../", "")) and (qrel["xpath"] == paragraphe[:xpath])}
				found += 1
			else
				error += 1
			end #if
		end #each
		
		rappel = found.to_f / nb_qrels.to_f if nb_qrels > 0
		precision = found.to_f / nb_paragraphes.to_f if nb_paragraphes > 0
		
		puts "found: " + found.to_s
		puts "error: " + error.to_s
		puts "rappel: " + rappel.to_s
		puts "precision: " + precision.to_s
		
		
		return Struct::ComparedQrel.new(rappel, precision)
	end
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	compare_qrel = CompareQrel.new()
	
	query = Queries.new
	qrel = query.get_qrel(" balade montagne amérique latine ")
	
end #if
