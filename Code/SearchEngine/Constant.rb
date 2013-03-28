
# DB
HOST="localhost"
USER="root"
PASSWORD="spve2000"
DATABASE="websemantique"

SIMPLE_TERM_WEIGHT = 10
SYNONYME_TERM_WEIGHT = 4
CHILD_TERM_WEIGHT = 2
INSTANCE_TERM_WEIGHT = 1

#Structure
Struct.new("ComparedQrel", :rappel, :precision)
Struct.new("Term", :id, :term, :label, :weight)
Struct.new("Qrel", :path_file, :xpath)
