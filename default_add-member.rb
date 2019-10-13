# ------------------------------------------------------------------------
# Author: Salman Taherizadeh - Jozef Stefan Institute (JSI)
# This code is published under the Apache 2 license
# ------------------------------------------------------------------------

execute 'mongo_shell2' do
	command "mongo localhost --eval 'rs.add(" + '"' + "ec2-20-60-100-120.eu-central-1.compute.amazonaws.com" + '"' + ")'"
	action :run
end
