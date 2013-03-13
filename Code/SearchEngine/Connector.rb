#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Constant'
require "mysql"

class Connector
	def initialize()
		Struct.new("Term", :id, :term, :label)
		dbh = Mysql.init
		dbh.options(Mysql::SET_CHARSET_NAME, 'utf8')
		@con = dbh.real_connect(HOST, USER, PASSWORD, DATABASE)
	end #initialize

	def get_term(word)
		st_select_term = @con.prepare("SELECT idterm FROM Term WHERE label = ?")
		term_value = nil
		
		# get values
		term_value = word[0, 6]
		result = st_select_term.execute(term_value)
		id_term = result.fetch[0]
		
		# Compute term
		term = Struct::Term.new(id_term, term_value, word) if not id_term.nil?
		
		return term
	end # get_term
	
	def get_all_paragraphs(terms)
		return get_paragraphs(terms, -1)
	end #get_paragraphs
	
	def get_paragraphs(terms, max_paragraphes)
		where_condition_weight = ""
		where_condition_term = ""
		paragraphs = []
		
		terms.each_with_index do |t, i|
			where_condition_weight += "(idterm = " + t.id.to_s + " and @weight := 1.0) "
			where_condition_term += "con.idTerm = " + t.id.to_s + " "
			if terms.size > (i + 1)
				where_condition_weight += "or "
				where_condition_term += "or "
			end # if
		end #each
		
		request = "SELECT par.xpath, doc.pathFile, SUM(terw.weight) as weight FROM Contain con, Document doc, Paragraph par,  "
		request += "(SELECT (weight * @weight) as weight, idParagraph, idTerm FROM Contain WHERE (" + where_condition_weight + ")) terw "
		request += "WHERE terw.idParagraph = con.idParagraph and par.idDocument = doc.idDocument and par.idParagraph = con.idParagraph and (" + where_condition_term +") "
		request += "GROUP BY con.idParagraph "
		request += "ORDER BY weight desc "
		if(max_paragraphes < 0)
			request += ";"
		else
			request += "Limit " + max_paragraphes.to_s + ";"
		end #if
		
		select = @con.prepare(request)
		result = select.execute
		result.each do |p|
			paragraphs << {xpath:p[0], pathFile:p[1], weight:p[2]}
		end
		
		return paragraphs
	end #get_paragraphs
	
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	con = Connector.new()
	montagne = con.get_term("montagne")
	plaine = con.get_term("plaine")
	
	terms = [montagne, plaine]
	
	puts "get 10"
	p con.get_paragraphs(terms, 10)
	
	puts "\n\n\n"
	
	puts "get all"
	p con.get_all_paragraphs(terms)
end #if
