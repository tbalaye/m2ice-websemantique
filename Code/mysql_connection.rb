#encoding: UTF-8

# This is script to test for mysql-ruby module.
# $Id: test.rb,v 1.1 2003/07/23 00:42:14 tommy Exp $
#
# Execute in mysql-ruby top directory.
# Modify following $host, $user, $passwd and $db if needed.
#  $host:   hostname mysql running
#  $user:   mysql username (not unix login user)
#  $passwd: mysql access passwd for $user
#  $db:     database name for this test. it must not exist before testing.

require "rubygems"
require "mysql"

$host = "localhost" # ARGV.shift
$user = "websemantique" # ARGV.shift
$passwd = "websemantique" # ARGV.shift

begin

	dbh = Mysql.init
	dbh.options(Mysql::SET_CHARSET_NAME, 'utf8')
    con = dbh.real_connect $host, $user, $passwd
    puts con.get_server_info
	puts con.character_set_name
	
    #rs = con.query 'SELECT VERSION()'
    #puts rs.fetch_row.chomp
    
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end

