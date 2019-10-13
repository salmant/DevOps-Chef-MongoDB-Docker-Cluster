# ------------------------------------------------------------------------
# Author: Salman Taherizadeh - Jozef Stefan Institute (JSI)
# This code is published under the Apache 2 license
# ------------------------------------------------------------------------

# Pull latest image
docker_image 'mongo' do
	tag 'latest'
	action :pull
end

# Run container
docker_container 'mongo' do
	repo 'mongo'
	tag 'latest'
	port '27017:27017'
	host_name 'ec2-20-60-100-120.eu-central-1.compute.amazonaws.com'
	extra_hosts ['ec2-44-12-91-174.eu-central-1.compute.amazonaws.com:44.12.91.174', 'ec2-20-60-100-120.eu-central-1.compute.amazonaws.com:20.60.100.120']
	command '--replSet rs0'
	detach true
	volume '/home/mongo-files/data:/data'
end

# Install the MongoDB client
package "mongodb-clients" do
	action :install
end
