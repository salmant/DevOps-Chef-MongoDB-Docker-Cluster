# DevOps: Setup a MongoDB cluster using Docker containers by Chef on Amazon EC2

NOTE: In order to proceed this guide, prior DevOps knowledge of working with the following technologies is highly required:

* Chef configuration management tools (Server, Workstation and Agents)
* Ruby for cookbooks
* MongoDB 
* Docker containers
* Amazon EC2 cloud infrastructure

MongoDB stores data records as BSON documents, which are binary representation of JSON documents. Therefore, an important distinction of MongoDB is that BSON data format provides more data types than JSON. MongoDB cluster is used to increase data availability through multiple copies of data on different database servers. To this end, replication has to be considered as the process of synchronising data across multiple MongoDB servers. MongoDB cluster not only allows DevOps to recover from hardware failure, but also prevent service interruptions. In this line, replica sets let DevOps create scalable, highly available database systems with drastically growing datasets. 
<br />
Here, I explain how to setup a MongoDB cluster using Docker containers by Chef on Amazon EC2 cloud infrastructure. In other words, how to setup a MongoDB replica set including two MongoDB Docker containers by custom shell scripts. The first replica is called "PRIMARY", and the second one is called "SECONDARY". Before you begin, make sure you have your own Chef DevOps tools such as Chef Server and Chef Workstation running. Especially, you need to make sure that an appropriate version of Chef Development Kit is already installed. I have used “chefdk_1.3.43-1_amd64.deb”, which works properly.
<br />
## Step 1: Find out all IP addresses and hostnames of Cluster Nodes
At first, we need to check all IP addresses and hostnames of two nodes (Node 1 and Node 2) on which we are going to deploy "PRIMARY" and "SECONDARY" MongoDB replicas, respectively. As example:
Node 1 ("PRIMARY")
<br />
IP: 44.12.91.174
Hostname: ec2-44-12-91-174.eu-central-1.compute.amazonaws.com

<br />
Node 2 ("SECONDARY")
IP: 20.60.100.120
Hostname: ec2-20-60-100-120.eu-central-1.compute.amazonaws.com

## Step 2: Bootstrap all Cluster Nodes
Chef allows us to bootstrap two nodes (Node 1 and Node 2) in order to install and configure the Chef Agent on both of them.

## Install the "PRIMARY" MongoDB replica
First, login to the Chef Workstation and go to the folder which consists of cookbooks.
<br />
`cd ~/chef-repo/cookbooks`
<br />

And download the Docker cookbook and name it as 'docker1' cookbook.
wget https://github.com/chef-cookbooks/docker/archive/master.zip
unzip master.zip
rm -r master.zip
mv docker-master docker1
cd docker1




## 

## 

## 

## 

## 

## 

## 


