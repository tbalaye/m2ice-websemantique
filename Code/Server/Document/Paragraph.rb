#encoding: UTF-8
$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'Document/Term'

class Paragraph
	attr_reader :terms, :xpath

	def initialize(xpath)
		@terms = []
		@xpath = xpath
	end # def
	
	def add_term(term)
		# Si le terme n'existe pas
		if(not @terms.include?(term))
			@terms << term
		else # Si le terme existe, on ajoutes les positions
			term_tmp = find_term(term)
			
			term.positions.each{|p| term_tmp.add_position(p)}
			
			term_tmp.is_in_title = true if term.is_in_title
		end #if
	end
	
	def add_paragraph(other)
		other.terms.each do |term|
			if(not terms.include?(term)) # On copie les élément non en double
				@terms << term
			else # On ajoute les position des termes identique, et on met à jour son status
				term_tmp = find_term(term)
				
				term.positions.each{|p| term_tmp.add_position(p)}
				
				term_tmp.is_in_title = true if term.is_in_title
			end #if
		end #each
	end #def
	
	# On ne prend pas en compte les mots inutile
	def nb_word
		count_tmp = 0
		
		terms.each{|e| count_tmp += e.occurences}
		
		return count_tmp
	end #def
	
	
	def compute_tf
		terms.each do |t|
			t.tf = t.occurences.to_f / (nb_word.to_f + t.occurences.to_f)
		end #each
	end
	
	private
	
	# On retourne le term contenu dans le paragraphe
	def find_term(term)
		return @terms.find{|t| t == term}
	end #def
end #class




if __FILE__ == $0
	paragraph1 = Paragraph.new("iojk")
	paragraph2 = Paragraph.new("fezf")


	term1 = Term.new("test1")
	term2 = Term.new("test2")
	term3 = Term.new("test1")
	term4 = Term.new("test4")
	term5 = Term.new("test2")
	term6 = Term.new("test1")

	term1.add_position(1)
	term1.add_position(2)
	term1.add_position(4)
	term2.add_position(23)
	term3.add_position(45)
	term3.add_position(2)


	term4.add_position(11)
	term4.add_position(33)
	term5.add_position(4)
	term5.add_position(2)

	term2.is_in_title = true
	term6.is_in_title = true

	paragraph1.add_term(term1)
	paragraph1.add_term(term2)
	paragraph1.add_term(term3)

	paragraph2.add_term(term4)
	paragraph2.add_term(term5)
	paragraph2.add_term(term6)
	
	paragraph1.compute_tf
	paragraph2.compute_tf

	p paragraph1
	puts "#"*42
	p paragraph2
	puts "#"*42
	paragraph1.add_paragraph(paragraph2)
	p paragraph1
	puts "#"*42
	paragraph1.compute_tf
	p paragraph1
end
