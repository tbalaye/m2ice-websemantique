
# DB
HOST="localhost"
USER="root"
PASSWORD="spve2000"
DATABASE="websemantique"

#Weight
SIMPLE_TERM_WEIGHT = 10
SYNONYME_TERM_WEIGHT = 4
CHILD_TERM_WEIGHT = 2
INSTANCE_TERM_WEIGHT = 1

#weifht minimum ou un document est accepté
WEIGHT_MIN = 1.5

#Structure
Struct.new("ComparedQrel", :rappel, :precision)
Struct.new("Term", :id, :term, :label, :weight)
Struct.new("Qrel", :path_file, :xpath)

