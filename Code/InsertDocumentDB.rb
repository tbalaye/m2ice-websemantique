#encoding: UTF-8
STDOUT.sync = true

require './Document_parse'
require './Constant'
require './Semaphore'

class InsertDocumentDB
	def initialize(connexion)
		# Initialisation des requêtes
		@st_insert_doc = connexion.prepare("INSERT INTO Document (label, pathFile) VALUES (?, ?) ON DUPLICATE KEY UPDATE label=VALUES(label)")
		@st_insert_paragraph = connexion.prepare("INSERT IGNORE INTO Paragraph(xpath, idDocument) Value(?, ?)")
		@st_insert_term = connexion.prepare("INSERT IGNORE INTO Term(label) Value(?)")
		@st_select_term = connexion.prepare("SELECT idterm FROM Term WHERE label = ?")
		@st_insert_contain = connexion.prepare("INSERT IGNORE INTO Contain(weight, isTitle, idTerm, idParagraph) Value(?, ?, ?, ?)")
		@st_insert_position_term = connexion.prepare("INSERT IGNORE INTO Position_Term(valuePos, word, idContain) Value(?, ?, ?)")
		
		@sem_insert_doc = Semaphore.new(1)
		@sem_insert_paragraph = Semaphore.new(1)
		@sem_insert_term = Semaphore.new(1)
		@sem_insert_contain = Semaphore.new(1)
		@sem_insert_position_term = Semaphore.new(1)
		
		@word = {}
	end #def
	
	# Insert des info du document
	def compute(document)
		insert_document(document)
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
			@sem_insert_paragraph.synchronize do			
				@st_insert_paragraph.execute(paragraph.xpath, id_document)
				id_paragraph = @st_insert_paragraph.insert_id
			end #synchronize
			
			insert_contains(paragraph.terms, id_paragraph)
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
		@sem_insert_term.synchronize do
			@st_insert_term.execute(term.label_short)
			# on vérifie que l'id est bon, sinon on le récupère dans la bd
			@word[term.label_short] = @st_insert_term.insert_id if @word[term.label_short] == nil
			@word[term.label_short] = @st_select_term.execute(term.label_short).fetch[0] if @word[term.label_short] == 0
		end #synchronize do
		
		return @word[term.label_short]
	end #def
	
	def insert_position_term(term, id_contain)
		@sem_insert_position_term.synchronize do
			term.positions.each do |position|
				@st_insert_position_term.execute(position, term.label, id_contain)
			end # each
		end #synchronize
	end #def
	
end #class
