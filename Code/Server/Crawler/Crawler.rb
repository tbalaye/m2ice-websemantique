#encoding: UTF-8
STDOUT.sync = true

$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'thread'
require 'observer'
require 'Document/Parse'
require 'Document/Document_parse'
require 'Document/InsertDocumentDB'
require 'Share/Semaphore'
require 'Share/Notifier_crawl'


class Crawler
  include Observable
	def initialize(documents, share, server, debug)
		@share = share
		@debug = debug
		add_observer(Notifier_crawl.new(server))
	end #def
	
	def run()
		# Indexer des documents
		@thread = Thread.new do
			puts "New crawling thread" if @debug
			doc = @share.take_document()
			while doc != nil
				puts "Begin crawl: "+ doc.to_s if @debug
				
				# Ajout du fichier crawler dans le fichier de partage
				doc_tmp = Parse.new(doc).document 
				@share.add_document_crawl(doc_tmp)
				
				# notify
				changed
				notify_observers(doc.to_s)
				
				puts "End crawl: "+ doc.to_s if @debug
				doc = @share.take_document()
			end #while
		end #each
	end #def
	
	def join()
		@thread.join
		puts "End Thread(s) crawling" if @debug
	end
end #class
