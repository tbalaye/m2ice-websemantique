#encoding: UTF-8
STDOUT.sync = true

$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'Document/Document_parse'
require 'Constant'
require 'Share/Semaphore'

class InsertDocumentDB
	def initialize(connexion)
		# Initialisation des requêtes
		@st_insert_doc = connexion.prepare("INSERT INTO Document (label, pathFile) VALUES (?, ?) ON DUPLICATE KEY UPDATE label=VALUES(label)")
		@st_insert_paragraph = connexion.prepare("INSERT IGNORE INTO Paragraph(xpath, idDocument) Value(?, ?)")
		@st_select_paragraph = connexion.prepare("SELECT idParagraph FROM Paragraph WHERE xpath = ? and idDocument = ?")
		@st_insert_term = connexion.prepare("INSERT IGNORE INTO Term(label) Value(?)")
		@st_select_term = connexion.prepare("SELECT idterm FROM Term WHERE label = ?")
		@st_insert_contain = connexion.prepare("INSERT IGNORE INTO Contain(weight, isTitle, idTerm, idParagraph) Value(?, ?, ?, ?)")
		@st_insert_position_term = connexion.prepare("INSERT IGNORE INTO Position_Term(valuePos, word, idContain) Value(?, ?, ?)")
		@con = connexion
			
		@sem_insert_doc = Semaphore.new(1)
		@sem_insert_contain = Semaphore.new(1)
		@sem_insert_paragraph = Semaphore.new(1)
		@sem_insert_term = Semaphore.new(1)
		
		@word = {}
	end #def
	
	# Insert des info du document
	def compute(document)
		insert_document(document)
		@con.commit
	end # def
	
	private
	
	# On ajoute le document, puis on passes au paragraphes
	def insert_document(document)
		id_doc = -1
		@sem_insert_doc.synchronize do
			@st_insert_doc.execute(document.title, document.path)
			id_doc = @st_insert_doc.insert_id
		end #synchronize
		
		insert_paragraphs(document.paragraphs, id_doc)
	end #def
	
	# On insére un paragraphe puis son contenu et on passe au paragraphe suivant
	def insert_paragraphs(paragraphs, id_document)
		id_paragraph = -1
			
		paragraphs.each do |paragraph|
			@st_insert_paragraph.execute(paragraph.xpath, id_document)
			
			@sem_insert_paragraph.synchronize do
				id_paragraph = @st_select_paragraph.execute(paragraph.xpath, id_document).fetch[0]
				insert_contains(paragraph.terms, id_paragraph)
			end #synchronize
		end #each
	end #def
	
	# On insére les terme du paragraphe, on fait ensuite le lien avec la table contenu et position
	def insert_contains(terms, id_paragraph)
		id_term = -1
		id_contain = -1
		
		terms.each do |term|
			id_term = insert_term(term)
			
			@sem_insert_contain.synchronize do
				@st_insert_contain.execute(term.weight, (term.is_in_title)? 1 : 0, id_term, id_paragraph)
				id_contain = @st_insert_contain.insert_id
			end #synchronize
			
			insert_position_term(term, id_contain)
		end #each
		
	end #def
	
	def insert_term(term)
		@st_insert_term.execute(term.label_short)
		
		@sem_insert_term.synchronize do
			if @word[term.label_short] == nil
				id_term = @st_select_term.execute(term.label_short).fetch[0]
				@word[term.label_short] = id_term
			end #if
		end #synchronize
		
		return @word[term.label_short]
	end #def
	
	def insert_position_term(term, id_contain)
		term.positions.each do |position|
			@st_insert_position_term.execute(position, term.label, id_contain)
		end # each
	end #def
	
end #class
