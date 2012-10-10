#encoding: UTF-8
STDOUT.sync = true
require 'rexml/document'
include REXML


require './Paragraph'
require './Constant'
require './Term'
require './Document_parse'


class Parse
	attr_reader :document
	
	def initialize(path)
		@words_not_use = []
		@document = Document_parse.new(path)

		#On ajoute les termes dont on ne va pas tenir compte
		fichier = File.open("./stoplist/stoplist.txt", "r")
		fichier.each_line {|ligne| @words_not_use << ligne.chomp.downcase}
		fichier.close
		
		# On calcule les éléments du document
		parse_document(path)	
	end
	
	private

	# On parse chaque section ou paragraphe seul
	def parse_document(path)
		file = File.new(path)
		doc = Document.new(file)
		root = doc.root

		root.elements.each("RECIT/SEC|RECIT"){|sec| parse_section(sec)}
		document.title = root.elements["PRESENTATION/TITRE"].text
		
		document.compute_idf()
	end # def

	def parse_section(sec)
		sous_titre_noeud = sec.elements["SOUS-TITRE"]
		sous_titre = parse_text(sous_titre_noeud, true) if sous_titre_noeud != nil
		paragraphes = []
		
		# On calcule tous les paragraphes de P
		sec.elements.each("P") {|paragraphe| paragraphes << parse_text(paragraphe, false)}
		
		# Si il y a un sous-titre
		if(sous_titre_noeud != nil)
			paragraphes.each{|p| p.add_paragraph(sous_titre)}
		end #if

		# On ajoute les paragraphes trouvés
		paragraphes.each do |p|
			p.compute_tf
			@document.add_paragraph(p)
		end
	end #def

	def parse_text(element, is_title)
		words = Paragraph.new(element.xpath.to_s.sub("BALADE/RECIT/", "BALADE[1]/RECIT[1]/").sub("SEC/", "SEC[1]/"))
		if element.text != nil
			text = element.text.downcase
			# Pour tous les mots
			text.scan(/([a-zàâçéèêëîïôûùüÿñæœ]+)/).each_with_index do |w, position|
				word_text = w[0].to_s
				if(!@words_not_use.include?(word_text) and word_text.size > 2) # On teste en Capitalize pour ne pas tenir compte de la case
					word = Term.new(word_text)
					word.is_in_title = is_title
					
					# Si on est pas dans le titre, on ajoute la position
					word.add_position(position) if(not is_title)
					
					# On ajoute le terme au paragraphe
					words.add_term(word)
				end #if
			end #split
		end # if
			
		return words
	end #def
end #class


if __FILE__ == $0
	test = Parse.new("./Collection/d001.xml")
	p test.document
end
