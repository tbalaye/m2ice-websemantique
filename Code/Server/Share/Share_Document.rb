#encoding: UTF-8
STDOUT.sync = true

$LOAD_PATH << File.dirname(__FILE__)
require 'Semaphore'


class Share_Document
	def initialize(documents)
		@documents = documents
		@nb_doc = documents.size
		@documents_crawl = []
		@sem_doc = Semaphore.new(1)
		@sem_doc_crawl = Semaphore.new(0)
	end #def
	
	def add_document_crawl(doc)
		@documents_crawl << doc
		@sem_doc_crawl.v
		
		@nb_doc -= 1
	end #def
	
	def take_document_crawl
		@sem_doc_crawl.p if not is_empty_document()
		return @documents_crawl.pop
	end #def
	
	def take_document()
		doc = nil
		
		@sem_doc.synchronize do
		 doc = @documents.pop
		end #synchronize
		
		return doc
	end #def
	
	def is_empty_document()
		return (@nb_doc == 0)
	end #def
end #class
