#encoding: UTF-8
STDOUT.sync = true

$LOAD_PATH << File.dirname(__FILE__)

require 'Document/InsertDocumentDB'
require 'Share/Semaphore'
require 'Crawler/Crawler'
require 'Indexer/Indexer'
require 'Share/Share_Document'

require 'thread'
require "rubygems"
require "mysql"


class Main_Crawl
	def initialize(server)
		@server = server
	end #def
	
	def run(host, user, password, database, nb_thread_crawl, nb_thread_index)
		documents = []
		services = []
		Dir.glob("./Collection/*.xml") { |d| documents << d }
		share = Share_Document.new(documents)
		

		begin
			dbh = Mysql.init
			dbh.options(Mysql::SET_CHARSET_NAME, 'utf8')
			con = dbh.real_connect(host, user, password, database)
			con.commit
			con.autocommit(false)
			insert_db = InsertDocumentDB.new(con)
			
			(1..nb_thread_crawl).each do
				crawler = Crawler.new(documents, share, @server, DEBUG)
				crawler.run()
				services << crawler
			end #each
			
			(1..nb_thread_index).each do
				indexer = Indexer.new(share, insert_db, @server, DEBUG)
				indexer.run()
				
				services << indexer
			end #each
			
			services.each {|s| s.join}
		rescue Mysql::Error => e
			con.rollback
			@server.error_db(e.to_s)
			puts "Error code: #{e.errno}"
			puts "Error message: #{e.error}"
			puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
		ensure
		 # disconnect from server
		 dbh.close if dbh
		end #begin
		
		@server.finish_compute()
	end #def
	
	def nb_documents
		documents = []
		
		Dir.glob("./Collection/*.xml") { |d| documents << d }
		
		return documents.size
	end #def
end #class
    


