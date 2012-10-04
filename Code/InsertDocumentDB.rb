#encoding: UTF-8

require './Document_parse'
require './Constant'

class InsertDocumentDB
	def initialize(connexion)
		# Initialisation des requêtes
		@st_insert_doc = connexion.prepare("INSERT INTO Document (label, pathFile) VALUES (?, ?) ON DUPLICATE KEY UPDATE label=VALUES(label)")
		@st_insert_paragraph = connexion.prepare("INSERT IGNORE INTO Paragraph(xpath, idDocument) Value(?, ?)")
		@st_insert_term = connexion.prepare("INSERT IGNORE INTO Term(label) Value(?)")
		@st_select_term = connexion.prepare("SELECT idterm FROM Term WHERE label = ?")
		@st_insert_contain = connexion.prepare("INSERT IGNORE INTO Contain(weight, isTitle, idTerm, idParagraph) Value(?, ?, ?, ?)")
		@st_insert_position_term = connexion.prepare("INSERT IGNORE INTO Position_Term(valuePos, word, idContain) Value(?, ?, ?)")
		@word = {}
	end #def
	
	# Insert des info du document
	def compute(document)
		insert_document(document)
	end # def
	
	private
	
	# On ajoute le document, puis on passes au paragraphes
	def insert_document(document)
		@st_insert_doc.execute(document.title, document.path)
		
		insert_paragraphs(document.paragraphs, @st_insert_doc.insert_id)
	end #def
	
	# On insére un paragraphe puis son contenu et on passe au paragraphe suivant
	def insert_paragraphs(paragraphs, id_document)
		paragraphs.each do |paragraph|
			@st_insert_paragraph.execute(paragraph.xpath, id_document)
				
			insert_contains(paragraph.terms, @st_insert_paragraph.insert_id)
		end #each
	end #def
	
	# On insére les terme du paragraphe, on fait ensuite le lien avec la table contenu et position
	def insert_contains(terms, id_paragraph)
		terms.each do |term|
			id_term = insert_term(term)
			@st_insert_contain.execute(term.weight, (term.is_in_title)? 1 : 0, id_term, id_paragraph)
			insert_position_term(term, @st_insert_contain.insert_id)
		end #each
	end #def
	
	def insert_term(term)
		@st_insert_term.execute(term.label_short)
		
		@word[term] = @st_insert_term.insert_id if @word[term] == nil
		
		
		if(@word[term] == 0)
			@word[term] = @st_select_term.execute(term.label_short).fetch[0]
		end # if
		
		return @word[term]
	end #def
	
	def insert_position_term(term, id_contain)
		term.positions.each do |position|
			@st_insert_position_term.execute(position, term.label, id_contain)
		end # each
	end #def
end #class
