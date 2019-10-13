# DevOps use case: Setup a MongoDB cluster using Docker containers by Chef on Amazon EC2

NOTE: In order to proceed this guide, prior DevOps knowledge of working with the following technologies is highly required:

* Chef configuration management tools (Server, Workstation and Agents)
* Ruby for cookbooks
* MongoDB 
* Docker containers
* Amazon EC2 cloud infrastructure

MongoDB stores data records as BSON documents, which are binary representation of JSON documents. Therefore, an important distinction of MongoDB is that BSON data format provides more data types than JSON. MongoDB cluster is used to increase data availability through multiple copies of data on different database servers. To this end, replication has to be considered as the process of synchronising data across multiple MongoDB servers. MongoDB cluster not only allows DevOps to recover from hardware failure, but also prevent service interruptions. In this line, replica sets let DevOps create scalable, highly available database systems with drastically growing datasets. 
<br><br>
Here, I explain how to setup a MongoDB cluster using Docker containers by Chef on Amazon EC2 cloud infrastructure. In other words, how to setup a MongoDB replica set including two MongoDB Docker containers by custom shell scripts. The first replica is called "PRIMARY", and the second one is called "SECONDARY". Before you begin, make sure you have your own Chef DevOps tools such as Chef Server and Chef Workstation running. Especially, you need to make sure that an appropriate version of Chef Development Kit is already installed. I have used “chefdk_1.3.43-1_amd64.deb”, which works properly.
<br>
## Step 1: Find out all IP addresses and hostnames of Cluster Nodes
At first, we need to check all IP addresses and hostnames of two nodes (Node 1 and Node 2) on which we are going to deploy "PRIMARY" and "SECONDARY" MongoDB replicas, respectively. As example:
<br>
<br>Node 1: "PRIMARY MongoDB replica"
<br>IP: `44.12.91.174`
<br>Hostname: `ec2-44-12-91-174.eu-central-1.compute.amazonaws.com`
<br>
<br>Node 2: "SECONDARY MongoDB replica"
<br>IP: `20.60.100.120`
<br>Hostname: `ec2-20-60-100-120.eu-central-1.compute.amazonaws.com`
<br>
## Step 2: Bootstrap all Cluster Nodes
Chef allows us to bootstrap two nodes (Node 1 and Node 2) in order to install and configure the Chef Agent on both of them.
<br>
## Step 3: Install the "PRIMARY" MongoDB replica
First, login to the Chef Workstation and go to the folder which consists of cookbooks.
<br>`cd ~/chef-repo/cookbooks`
<br>
<br>And download the Docker cookbook and name it as 'docker1' cookbook.
<br>`wget https://github.com/chef-cookbooks/docker/archive/master.zip`
<br>`unzip master.zip`
<br>`rm -r master.zip`
<br>`mv docker-master docker1`
<br>`cd docker1`
<br>
<br>Change the name of cookbook as 'docker1' written in `metadata.rb`.
<br>`nano metadata.rb`
<br>----> `name 'docker1'`
<br>
<br>Write the default recipe for cookbook 'docker1'.
<br>`mkdir recipes`
<br>`cd recipes`
<br>`nano default.rb`
<br>The file is accessible here: [default.rb](https://github.com/salmant/DevOps-Chef-MongoDB-Docker-Cluster/blob/master/default_docker1.rb)
<br>
<br>Note: In default.rb file,`extra_hosts` adds the mentioned entries into the Docker container’s `/etc/hosts` file. Therefore, hostnames can be used instead of IP addresses in the production environment.
<br>
<br>Note: In MongoDB, `27017` is the default port number. If you may have any reason to apply a different port number, it is possible. However, the rest of this guide will employ the default port number.
<br>
<br>Note: The replica set name is specified as `rs0` by using the option `replSet`.
<br>
<br>Note: The "volume" flag mounts the working directory on the Docker host (`/home/mongo-files/data`) into the container (`/data`).
<br>
<br>Before uploading the cookbook, check the syntax first.
<br>`knife cookbook test docker1`
<br>
<br>Upload the cookbook on the Chef Server from the Chef Workstation.
<br>`knife cookbook upload docker1`
<br>
<br>Add the recipe in the cookbook named 'docker1' to the Node 1’s run list.
<br>`knife node run_list add node1 "recipe[docker1]"`
<br>
<br>Apply configurations defined in the cookbook named 'docker1' on Node 1 on the Amazon EC2 platform with Ubuntu. In this case "key1.pem" is the real private key file for Node 1.
<br>`knife ssh 'name:node1' 'sudo chef-client' -x ubuntu -i ~/chef-repo/.chef/key1.pem`
<br>
<br>Remove the recipe in the cookbook named 'docker1' from the Node 1’s run list.
<br>`knife node run_list remove node1 "recipe[docker1]"`
<br>
## Step 4: Install the "SECONDARY" MongoDB replica
In order to ease our procedure, we make a copy named 'docker2' from cookbook 'docker1'. 
<br>`cd ~/chef-repo/cookbooks`
<br>`cp -r docker1 docker2`
<br>`cd docker2`
<br>
<br>Change the name of cookbook as 'docker2' written in `metadata.rb`.
<br>`nano metadata.rb`
<br>----> `name 'docker2'`
<br>
Write the default recipe for cookbook 'docker2'.
<br>`cd recipes`
<br>`rm -r default.rb`
<br>`nano default.rb`
<br>The file is accessible here: [default.rb](https://github.com/salmant/DevOps-Chef-MongoDB-Docker-Cluster/blob/master/default_docker2.rb)
<br>
<br>Note: The replica set name for the "SECONDARY" MongoDB replica is again specified as `rs0` by using the option `replSet`, similar to what we determined for the "PRIMARY" MongoDB replica.
<br>
<br>Before uploading the cookbook, check the syntax first.
<br>`knife cookbook test docker2`
<br>
<br>Upload the cookbook on the Chef Server from the Chef Workstation.
<br>`knife cookbook upload docker2`
<br>
<br>Add the recipe in the cookbook named 'docker2' to the Node 2’s run list.
<br>`knife node run_list add node2 "recipe[docker2]"`
<br>
<br>Apply configurations defined in the cookbook named 'docker2' on Node 2 on the Amazon EC2 platform with Ubuntu. In this case "key2.pem" is the real private key file for Node 2.
<br>`knife ssh 'name:node2' 'sudo chef-client' -x ubuntu -i ~/chef-repo/.chef/key2.pem`
<br>
<br>Remove the recipe in the cookbook named 'docker2' from the Node 2’s run list.
<br>`knife node run_list remove node2 "recipe[docker2]"`
<br>
## Step 5: Initiate the replica set
In order to initiate the replica set, we need to run `rs.initiate()` in the MongoDB shell of the "PRIMARY" replica. To this end, we create a new cookbook named 'initiate-replica-set'.
<br>
<br>`cd ~/chef-repo/cookbooks`
<br>`cp -r docker1 initiate-replica-set`
<br>`cd initiate-replica-set`
<br>
<br>Change the name of cookbook as 'initiate-replica-set' written in `metadata.rb`.
<br>`nano metadata.rb`
<br>----> `name 'initiate-replica-set'`
<br>
<br>Write the default recipe for cookbook 'initiate-replica-set'.
<br>`cd recipes`
<br>`rm -r default.rb`
<br>`nano default.rb`
<br>The file is accessible here: [default.rb](https://github.com/salmant/DevOps-Chef-MongoDB-Docker-Cluster/blob/master/default_initiate-replica-set.rb)
<br>
<br>Before uploading the cookbook, check the syntax first.
<br>`knife cookbook test initiate-replica-set`
<br>
<br>Upload the cookbook on the Chef Server from the Chef Workstation.
<br>`knife cookbook upload initiate-replica-set`
<br>
<br>Add the recipe in the cookbook named 'initiate-replica-set' to the Node 1’s run list.
<br>`knife node run_list add node1 "recipe[initiate-replica-set]"`
<br>
<br>Apply configurations defined in the cookbook named 'initiate-replica-set' on Node 1 on the Amazon EC2 platform with Ubuntu. In this case "key1.pem" is the real private key file for Node 1.
<br>`knife ssh 'name:node1' 'sudo chef-client' -x ubuntu -i ~/chef-repo/.chef/key1.pem`
<br>
<br>Remove the recipe in the cookbook named 'initiate-replica-set' from the Node 1’s run list.
<br>`knife node run_list remove node1 "recipe[initiate-replica-set]"`
<br>
## Step 6: Add the "SECONDARY" MongoDB replica into the replica set
In order to add other nodes into the replica set, we need to run `rs.add()` in the MongoDB shell of the "PRIMARY" replica. To this end, we create a new cookbook named 'add-member'.
<br>
<br>`cd ~/chef-repo/cookbooks`
<br>`cp -r docker1 add-member`
<br>`cd add-member`
<br>
<br>Change the name of cookbook as 'add-member' written in `metadata.rb`.
<br>`nano metadata.rb`
<br>----> `name 'add-member'`
<br>
<br>Write the default recipe for cookbook 'add-member'.
<br>`cd recipes`
<br>`rm -r default.rb`
<br>`nano default.rb`
<br>The file is accessible here: [default.rb](https://github.com/salmant/DevOps-Chef-MongoDB-Docker-Cluster/blob/master/default_add-member.rb)
<br>
<br>Before uploading the cookbook, check the syntax first.
<br>`knife cookbook test add-member`
<br>
<br>Upload the cookbook on the Chef Server from the Chef Workstation.
<br>`knife cookbook upload add-member`
<br>
<br>Add the recipe in the cookbook named 'add-member' to the Node 1’s run list.
<br>`knife node run_list add node1 "recipe[add-member]"`
<br>
<br>Apply configurations defined in the cookbook named 'add-member' on Node 1 on the Amazon EC2 platform with Ubuntu. In this case "key1.pem" is the real private key file for Node 1.
<br>`knife ssh 'name:node1' 'sudo chef-client' -x ubuntu -i ~/chef-repo/.chef/key1.pem`
<br>
<br>Remove the recipe in the cookbook named 'add-member' from the Node 1’s run list.
<br>`knife node run_list remove node1 "recipe[add-member]"`
<br>
## Check if the cluster is well-established
In order to check whether the replica set is deployed properly or not, we need to connect to the MongoDB shell of the "PRIMARY" replica, and run `rs.status()`.
<br>`mongo 44.12.91.174 --eval 'printjson(rs.status())'`
<br>
<br>Note: In the output, you should see the state of Node 1 (id:0) as "PRIMARY" and the state of Node 2 (id:1) as "SECONDARY".
<br>`"_id" : 0` ---> `"stateStr" : "PRIMARY"`
<br>`"_id" : 1` --->  `"stateStr" : "SECONDARY"`

