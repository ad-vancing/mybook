# Amazon Elastic Compute Cloud (EC2)

vertically scaling an instance:  you can make instances bigger or smaller whenever you need to.

## different types of EC2 Instances  
Instance types offer varying combinations of CPU, memory, storage, and networking capacity, and give you the flexibility to choose the appropriate mix of resources for your applications.

- general purpose  
provide a good balance of compute, memory and networking resources

- compute optimized  
are ideal for compute intensive tasks like gaming service, high performance computing, or HPC, and even scientific modeling. 

- memory optimized

- accelerated computing
are good for floating point number calculations, graphics processing, or data pattern matching, as they use hardware accelerators.

- storage optimized
high performance for locally stored data.

## multiple billing options
- on demand
pay-as-you-go pricing  
pay for the duration that your instance runs for

- reserved instances  
workloads or ones with predictable usage

- spot instances
 if your workloads can tolerate being interrupted.
 
# Amazon EC2 auto-scaling
Scalability and elasticity
>handle growing demands 
>scale up or scale out.  
Scaling up means adding more power to the machines that are running.

solved the scaling problem with **Amazon EC2 auto-scaling**

# elastic load balancing
 is a regional construct ， ELB is designed to handle the additional throughput with no change the hourly cost.
 
# SQS && SNS
for loosely coupled, decouple system components 

- Amazon Simple Queue Service 


- Amazon Simple Notification Service  
a publish/subscribe or pub/sub model.  
an SNS topic, which is just a channel for messages to be delivered.

# other services
- EC2 
If you are trying to host traditional applications, and want full access to the underlying operating system, like Linux or Windows, you are going to want to use EC2.

- serverless AWS Lambda 
If you are looking to host short running functions, service-oriented, or event-driven applications, and you don’t want to manage the underlying environment at all, look into the serverless AWS Lambda.

- Amazon ECS, or Amazon EKS? 
If you are looking to run Docker container-based workloads on AWS, you first need to choose your orchestration tool.

- AWS Fargate
a serverless compute platform for ECS or EKS

# regions
Inside each region, there are multiple data centers that have all the compute storage and other services you need to run your applications.

Each region can be connected to each other region through a high speed fiber network controlled by AWS.

And each region is isolated from every other region .

AWS Regions are independent from one another. This means that your data is not replicated from one Region to another, without your explicit consent and authorization.

use Region-scoped, managed services. These services come with availability and resiliency built in.

## Which region do you pick? 
four key factors to choose a region: compliance, proximity, feature availability, and pricing.

compliance, latency, price（ Instead of charging a flat rate worldwide, AWS charges based on the financial factors specific to the location）, and service availability.
 
## availability zone  for high availability and disaster proof 
AWS region consists of multiple, isolated, and physically separate availability zones within a geographic region.

An AZ consists of one or more data centers with redundant power, networking, and connectivity.

Each availability zone is one or more discrete data centers with redundant power, networking, and connectivity.

some services ask you to specify an AZ. With these services, you are often responsible for increasing the data durability and high availability of these resources.

Recommend you run across at least two availability zones in a region.


## Amazon CloudFront, cdn
Caching copies of data closer to the customers all around the world uses the concept of content delivery networks or CDNs.

Amazon CloudFront uses what are called Edge locations all around the world to help accelerate communication with users no matter where they are.

## Edge locations 
An edge location is a site that Amazon CloudFront uses to store cached copies of your content closer to your customers for faster delivery.  
Edge locations are separate from regions, so you can push content from inside a region to a collection of Edge locations around the world in order to accelerate communication and content delivery.

## Amazon Route 53, a domain name service or DNS
helping direct customers to the correct web locations with reliably low latency.

## AWS Outposts, within your own building
 where AWS will basically install a fully operational mini region right inside your own data center

## sum up of regions
- regions are geographically isolated areas where you can access services needed to run your enterprise.
- regions contain availability zones that allow you to run across physically separated buildings, tens of miles of separation, while keeping your application logically unified.
Availability zones help you solve high availability and disaster recovery scenarios without any additional effort on your part.
- AWS Edge locations run Amazon CloudFront to help get content closer to your customers no matter where they are in the world.