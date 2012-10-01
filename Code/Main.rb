#encoding: UTF-8

require './Parse'
require './Document_parse'
require 'thread'
require './Constant'
require './InsertDocumentDB'

require "rubygems"
require "mysql"


documents = []

		
if not DEBUG
	pourcentage_new = 0
	pourcentage_old = 0
	 
	 puts "Crawling:"
	 puts "_" * 50
end

(1..NBDOCUMENTS).each do |e|
	id = ""
	id += "0" if(e < 100)
	id += "0" if(e < 10)
	id += e.to_s
	
	document_tmp = Parse.new("./Collection/d" + id + ".xml").document
	documents << document_tmp if document_tmp.paragraphs.count > 0
	
	if not DEBUG
		pourcentage_new = ((e / NBDOCUMENTS.to_f) * 100).to_i
		
		if pourcentage_new > pourcentage_old + 1
			print "#" * (pourcentage_new - pourcentage_old - 1) % 2
			pourcentage_old = pourcentage_new
		end # if
	end # if
end #each

nb_doc = documents.count
puts "\nNumber of documents crawled : " + nb_doc.to_s + "\n\n"

begin
	dbh = Mysql.init
	dbh.options(Mysql::SET_CHARSET_NAME, 'utf8')
    con = dbh.real_connect HOST, USER, PASSWD, DATABASE
    insert = InsertDocumentDB.new(con)
	indice = 0
    
    if not DEBUG
		pourcentage_new = 0
		pourcentage_old = 0

		puts "Indexing:"
		puts "_" * 50
	end
    documents.each do |doc|
		indice +=1
		insert.compute(doc)
		if not DEBUG
			pourcentage_new = ((indice / nb_doc.to_f) * 100).to_i

			if pourcentage_new > pourcentage_old + 1
				print "#" * (pourcentage_new - pourcentage_old - 1) % 2
				pourcentage_old = pourcentage_new
			end # if
		end # if
    end
    
    
	puts "\nNumber of documents indexed : " + nb_doc.to_s

    
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end
