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
<br>Node 1 ("PRIMARY")
<br>IP: `44.12.91.174`
<br>Hostname: `ec2-44-12-91-174.eu-central-1.compute.amazonaws.com`
<br>
<br>Node 2 ("SECONDARY")
<br>IP: `20.60.100.120`
<br>Hostname: `ec2-20-60-100-120.eu-central-1.compute.amazonaws.com`

## Step 2: Bootstrap all Cluster Nodes
Chef allows us to bootstrap two nodes (Node 1 and Node 2) in order to install and configure the Chef Agent on both of them.

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
<br>Change the name of cookbook as 'docker1' written in “metadata.rb”.
<br>`nano metadata.rb`
<br>----> `name 'docker1'`
<br>
<br>Write the default recipe for cookbook 'docker1'.
<br>`mkdir recipes`
<br>`cd recipes`
<br>`nano ]default.rb](https://github.com/salmant/DevOps-Chef-MongoDB-Docker-Cluster/blob/master/default_docker1.rb)`

<br>Note: In default.rb file,"extra_hosts" adds the mentioned entries into the Docker container’s "/etc/hosts" file. Therefore, hostnames can be used instead of IP addresses in the production environment.
<br>
<br>Note: In MongoDB, 27017 is the default port number. If you may have any reason to apply a different port number, it is possible. However, the rest of this guide will employ the default port number.
<br>
<br>Note: The replica set name is specified as "rs0" by using the option "replSet".
<br>
<br>Note: The "volume" flag mounts the working directory on the Docker host ("/home/mongo-files/data") into the container ("/data").







## 

## 

## 

## 

## 

## 

## 


