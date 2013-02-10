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
	
	def get_paragraphs(terms)
		where_condition = "(select (weight * @weight) as weight, idParagraph, idTerm from contain where "
		terms.each_with_index do |t, i|
			where_condition += "(idterm = " + t.id.to_s + " and @weight := 1.0) "
			where_condition += "or " if terms.size < (i + 1)
		end #each
		
		p where_condition
	
	
		select = @con.prepare("set @weight:=0;" +
								"select par.xpath, doc.pathFile, sum(terw.weight) as weight from" +
									"contain con, document doc, paragraph par, "+
									"(select (weight * @weight) as weight, idParagraph, idTerm from contain where " + where_condition + ") terw where" + 
										"terw.idParagraph = con.idParagraph and par.idDocument = doc.idDocument and par.idParagraph = con.idParagraph and (" +
											"..." +
										") group by con.idParagraph " +
										"order by con.idParagraph desc;")
		
		
		
=begin
		        // Building Contain request part
                StringBuilder requestContain = new StringBuilder();
                requestContain.Append("(select (weight * @weight) as weight, idParagraph, idTerm from contain where ");
                inc = 1;
                foreach (Term term in terms)
                {
                    requestContain.Append("(idterm = " + term.IdTerm + " and @weight := " + 1.0 + ") ");
                    if (inc < terms.Count)
                    {
                        requestContain.Append("or ");
                        inc += 1;
                    }
                }
                requestContain.Append(")");

                // Building main request
                StringBuilder request = new StringBuilder();
                request.Append("set @weight:=0;");
                request.Append("select par.xpath, doc.pathFile, sum(terw.weight) as weight ");
                request.Append("from ");
                request.Append("contain con, ");
                request.Append("document doc, ");
                request.Append("paragraph par, ");
                request.Append(requestContain.ToString() + " terw ");
                request.Append("where ");
                request.Append("terw.idParagraph = con.idParagraph and ");
                request.Append("par.idDocument = doc.idDocument and ");
                request.Append("par.idParagraph = con.idParagraph and ");
                request.Append("(");
                inc = 1;
                foreach (Term term in terms)
                {
                    request.Append("con.idTerm = " + term.IdTerm + " ");
                    if (inc < terms.Count)
                    {
                        request.Append("or ");
                        inc += 1;
                    }
                }
                request.Append(") ");
                request.Append("group by con.idParagraph ");
                request.Append("order by con.idParagraph desc;");
=end
	
	end #get_paragraphs
	
	private
	
end #Connector


# Restriction à l'exécution : il n'est pas exécuté si il est juste importé
if __FILE__ == $0
	con = Connector.new()
	montagne = con.get_term("montagne")
	plaine = con.get_term("plaine")
	
	terms = [montagne, plaine]
	
	p con.get_paragraphs(terms)
end #if
