#encoding: UTF-8
STDOUT.sync = true

$LOAD_PATH << File.dirname(__FILE__) + "/../"

require 'Document/Document_parse'
require 'Document/InsertDocumentDB'
require 'Share/Semaphore'
require 'Share/Notifier_index'

require "rubygems"
require "mysql"
require 'thread'
require 'observer'

class Indexer
  include Observable
	def initialize(share, insert_db, server, debug)
		@share = share
		@insert_db = insert_db
		@debug = debug
		
		add_observer(Notifier_index.new(server))
	end #def
	
	def run()
		@thread = Thread.new do
			puts "New indexing thread" if @debug
			
			doc_crawl = @share.take_document_crawl()
			while doc_crawl != nil or not @share.is_empty_document
				puts "Begin index: "+  doc_crawl.path if @debug
				
				@insert_db.compute(doc_crawl)
				
				# notify
				changed
				notify_observers(doc_crawl.path)
				
				puts "End index: " +  doc_crawl.path if @debug
				doc_crawl = @share.take_document_crawl()
			end #while
		end #Thread
	end #def
	
	def join()
		@thread.join
		puts "End Thread(s) indexing" if @debug
	end
end #class
