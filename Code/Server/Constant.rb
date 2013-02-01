$LOAD_PATH << File.dirname(__FILE__)


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

