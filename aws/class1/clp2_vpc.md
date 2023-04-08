#  interact with aws services
## API
- management console

- Command Line Interface
 Writing commands using the CLI makes actions scriptable and repeatable.

- Software Development Kits or SDKs

## Elastic Beanstalk
a service that helps you provision Amazon EC2 based environments.

## AWS CloudFormation
an infrastructure as code tool, that allows you to define a wide variety of AWS resources in a declarative way using JSON or YAML text based documents, called CloudFormation Templates


# Amazon Virtual Private Cloud or VPCs
A [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html) lets you provision a logically isolated section of the AWS cloud where you can launch AWS resources in a virtual network that you define. 
These resources can be public-facing so they have access to the Internet or private with no Internet access, usually, for back-end services like databases or application servers. 

>notice:   
EC2 instances are placed in a network called the default Amazon Virtual Private Cloud (VPC). 
This network was created so that you can easily get started with Amazon EC2 without having to learn how to create and configure a VPC. 
you should change this default setting to choose your own custom VPCs and restrict access with additional routing and connectivity mechanisms.


https://web.stanford.edu/class/cs101/network-1-introduction.html


## subnets
are ranges of IP addresses in your VPC.   
Subnets are chunks of IP addresses in your VPC that allow you to group resources together.  

When working with networks in the AWS Cloud, you choose your network size by using [CIDR notation](https://www.ionos.com/digitalguide/server/know-how/cidr-classless-inter-domain-routing/). 
In AWS, the smallest IP range you can have is /28, which provides you 16 IP addresses. 
The largest IP range you can have is a /16, which provides you with 65,536 IP addresses. 

## Internet gateway, or IGW
public-facing resources  
like a doorway that is open to the public

## a virtual private gateway 
internal private resources  
establish an encrypted VPN connection to your VPC

## AWS Direct Connect
allows you to establish a completely private, dedicated fiber connection from your data center to AWS.
 
  
## network access control list or Network ACL
network ACLs as passport control officers.Network ACL gets to evaluate a packet if it crosses a subnet boundary, in or out.     
Packets are messages from the internet, and every packet that crosses the subnet boundaries, gets checked.  
This check is to see if the packet has permissions to either leave or enter the subnet, based on who it was sent from and how it's trying to communicate.

## Security Groups, instance level network security
Sometimes you'll have multiple EC2 Instances in the same subnet, but ACL doesn't evaluate if a packet can reach a specific EC2 Instance or not.

Every EC2 Instance, when it's launched automatically comes the Security Group.  
By default, the Security Group does not allow any traffic into the instance at all and all traffic is allowed out.

The key difference between a Security Group and a Network ACL is that the Security Group is stateful. 

## create a VPC 
When you create a VPC you have to declare two specific settings, the region you're selecting and the IP range for the VPC in the form of CIDR notation.  

After you create your VPC, you then divide the space inside the VPC into smaller segments called subnets. You put your resources. such as your EC2 Instances, inside of these subnets.

If I have more private resources like a database, I could create another subnet and have different controls to keep those resources private. To create a subnet, you need three main things, the VPC you want your subnet to live in which is this one, the AZ you want your subnet to live in, in this case we'll choose AZ-A or in other words US-West-2a and then the IP range for your subnet which must be a subset of the VPC IP range.

# Route 53
AWS's domain name service or DNS, and it's highly available and calable. it translates website names into IP or internet protocol addresses that computers can read.
   

