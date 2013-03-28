#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__)

require 'Constant'
require "mysql"

class Connector
	def initialize()
		dbh = Mysql.init
		dbh.options(Mysql::SET_CHARSET_NAME, 'utf8')
		@con = dbh.real_connect(HOST, USER, PASSWORD, DATABASE)
	end #initialize

	def get_term(word, weight)
		st_select_term = @con.prepare("SELECT idterm FROM Term WHERE label = ?")
		term_value = nil
		
		# get values
		term_value = word[0, 6]
		result = st_select_term.execute(term_value)
		if st_select_term.num_rows > 0
			id_term = result.fetch[0]
			
			# Compute term
			term = Struct::Term.new(id_term, term_value, word, weight) if not id_term.nil?
			
			return term
		else
			return nil
		end #if
	end # get_term
	
	def get_all_paragraphs(terms)
		return get_paragraphs(terms, -1)
	end #get_paragraphs
	
	# all terms != nil
	def get_paragraphs(terms, max_paragraphes)
		where_condition_weight = ""
		where_condition_term = ""
		paragraphs = []
		
		terms.each_with_index do |t, i|
			where_condition_weight += "(idterm = " + t.id.to_s + " and @weight := " + t["weight"].to_s + ") "
			where_condition_term += "con.idTerm = " + t.id.to_s + " "
			if terms.size > (i + 1)
				where_condition_weight += "or "
				where_condition_term += "or "
			end # if
		end #each
		
		request = "SELECT result.xpath, result.pathFile, result.weight FROM "
		request += "(SELECT par.xpath, doc.pathFile, SUM(terw.weight) as weight FROM Contain con, Document doc, Paragraph par,  "
		request += "(SELECT (weight * @weight) as weight, idParagraph, idTerm FROM Contain WHERE (" + where_condition_weight + ")) terw "
		request += "WHERE terw.idParagraph = con.idParagraph and par.idDocument = doc.idDocument and par.idParagraph = con.idParagraph and (" + where_condition_term +") "
		request += "GROUP BY con.idParagraph "
		request += "ORDER BY weight desc) result "
		request += "WHERE result.weight > " + WEIGHT_MIN.to_s + " "
		if(max_paragraphes < 0)
			request += ";"
		else
			request += "Limit " + max_paragraphes.to_s + ";"
		end #if
		
		select = @con.prepare(request)
		result = select.execute
		result.each do |p|
			get_content(p[0], p[1])
			paragraphs << {xpath:p[0], pathFile:p[1], weight:p[2], content: get_content(p[0], p[1])}
		end
		
		return paragraphs
	end #get_paragraphs
	
	private
	
	def get_content(xpath, pathfile)
		content = ""
		File.open( File.dirname(__FILE__) + "/" + pathfile) do |file|
			doc = Document.new(file)
			root = doc.root
			content = root.elements[xpath].text
		end #open
		
		return content
	end # get_content
	
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	con = Connector.new()
	montagne = con.get_term("montagne", 1)
	plaine = con.get_term("plaine", 2)
	
	terms = [montagne, plaine]
	
	puts "get 10"
	p con.get_paragraphs(terms, 10)
	
	puts "\n\n\n"
	
	puts "get all"
	p con.get_all_paragraphs(terms)
end #if
