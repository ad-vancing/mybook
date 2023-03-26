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
A VPC lets you provision a logically isolated section of the AWS cloud where you can launch AWS resources in a virtual network that you define. 
These resources can be public-facing so they have access to the Internet or private with no Internet access, usually, for back-end services like databases or application servers. 

## subnets
are ranges of IP addresses in your VPC.   
Subnets are chunks of IP addresses in your VPC that allow you to group resources together.   

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

# Route 53
AWS's domain name service or DNS, and it's highly available and calable. it translates website names into IP or internet protocol addresses that computers can read.
   

