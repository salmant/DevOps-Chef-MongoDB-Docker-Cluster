# ------------------------------------------------------------------------
# Author: Salman Taherizadeh - Jozef Stefan Institute (JSI)
# This code is published under the Apache 2 license
# ------------------------------------------------------------------------

execute 'mongo_shell1' do
	command "mongo localhost --eval 'rs.initiate()'"
	action :run
end
