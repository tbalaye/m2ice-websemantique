#encoding: UTF-8
STDOUT.sync = true

require './Parse'
require './Document_parse'
require 'thread'
require './Constant'
require './InsertDocumentDB'
require './Semaphore'
require './Crawler'
require './Indexer'

require "rubygems"
require "mysql"


documents = []



Dir.glob("./Collection/*.xml") do |d|
	documents << d
end #each

crawler = Crawler.new(documents, NBTHREADCRAWL, DEBUG)
crawler.run()


begin
	dbh = Mysql.init
	dbh.options(Mysql::SET_CHARSET_NAME, 'utf8')
    con = dbh.real_connect(HOST, USER, PASSWD, DATABASE)
    insert = InsertDocumentDB.new(con)
    
	indexer = Indexer.new(crawler, NBTHREADINDEX, insert, DEBUG)
	indexer.run()
	
	crawler.stop()
	indexer.stop()
    
rescue Mysql::Error => e
    puts e.errno
    puts e.error
ensure
    con.close if con
end


