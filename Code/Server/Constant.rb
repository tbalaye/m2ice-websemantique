$LOAD_PATH << File.dirname(__FILE__)

require 'logger'

#encoding: UTF-8
DEBUG = false

########################## Thread ##########################
NBTHREADCRAWL = 1
NBTHREADINDEX = 1

########################## DB ##########################
#HOST = "localhost"
#USER = "websemantique"
#PASSWD = "websemantique"
#DATABASE = "websemantique"

########################## Server ##########################
# Conf
PORT = 8080

# Signal send
HELLO = "101"
CRAWLDOC = "102"
INDEXDOC = "103"
NBDOC = "104" # arg nombre de docs
FINISH = "105"

# Signal receive
EXIT = "201"
START = "202" #args : host user password database [nbThreadCrawl (default 1) nbThreadIndex (default 1)]
COUNTDOC = "203"


# Erreur
ERRORDB = "301"
ERRORCOMMAND = "302" # arg : "'missing: ' + arg"
UNKNOWNCOMMAND = "303"

# Ontologie
URL_ONTOLOGIE = "172.31.190.49"
PORT_ONTOLOGIE = "3030"
ONTOLOGY_FILE_PATH = './ontologies/Baladefusion.owl'

# Webservice



# log
# Création du répertoire et du fichiers de log, découpé tous les 1024000 bytes et sauvegardés dans des fichiers '.old'
URL_LOG = File.dirname(__FILE__) + "/Logs"

if not File.directory?(URL_LOG)
	Dir::mkdir(URL_LOG, 0775)
end #if
LOG = Logger.new(URL_LOG + '/back-end.log', 10, 1024000)
LOG.level = Logger::INFO
