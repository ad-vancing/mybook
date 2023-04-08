# Amazon Elastic Compute Cloud (EC2)
>there are three types of compute options: virtual machines, container services, and serverless. 
In AWS, these virtual machines are called Amazon Elastic Compute Cloud or Amazon EC2. Behind the scenes, AWS operates and manages the host machines and the hypervisor layer. AWS also installs the virtual machine operating system, called the guest operating system.

[Amazon EC2](https://aws.amazon.com/ec2/) is a web service that provides secure, resizable compute capacity in the cloud. It allows you to provision virtual servers called EC2 instances. Although AWS uses the phrase “web service” to describe it, it doesn’t mean that you are limited to running just web servers on your EC2 instances.

vertically scaling an instance:  you can make instances bigger or smaller whenever you need to.

In order to create an EC2 instance, you need to define:

- Hardware specifications, like CPU, memory, network, and storage.

- Logical configurations, like networking location, firewall rules, authentication, and the operating system of your choice.

Stopping an instance is like powering down your laptop.

Terminating EC2 instance is make it recovery, so anything on that instance goes with it.

##  EC2 Instance Lifecycle
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html

- pending: When you launch an instance, it enters the pending state (1). When the instance is pending, billing has not started. At this stage, the instance is preparing to enter the running state. Pending is where AWS performs all actions needed to set up an instance, such as copying the AMI content to the root device and allocating the necessary networking components.

- running: When your instance is running (2), it's ready to use. This is also the stage where billing begins. As soon as an instance is running, you are then able to take other actions on the instance, such as reboot, terminate, stop, and stop-hibernate.

- Rebooting: When you reboot an instance (3),  Rebooting an instance is equivalent to rebooting an operating system. The instance remains on the same host computer and maintains its public and private IP address, and any data on its instance store.

- stopping: When you stop and start an instance (4), your instance may be placed on a new underlying physical server. Therefore, you lose any data on the instance store that were on the previous host computer. When you stop an instance, the instance gets a new public IP address but maintains the same private IP address.

When you terminate an instance (5), the instance store are erased, and you lose both the public IP address and private IP address of the machine. Termination of an instance means you can no longer access the machine.

Difference Between Stop and Stop-Hibernate?

##  Amazon Machine Image or an AMI
The [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) contains information about how you want your instance to be configured, including the operating system, possible applications to be pre-installed on that instance upon launch, and other configurations.   

One advantage of using AMIs is that they are reusable. 

[ Creating an Amazon EBS-backed Linux AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html)

[What Is EC2 Image Builder?](https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html)

## different types of EC2 Instances  
Instance types offer varying combinations of CPU, memory, storage, and networking capacity, and give you the flexibility to choose the appropriate mix of resources for your applications.

- general purpose  
provide a good balance of compute, memory and networking resources.  
Use Cases : Scale-out workloads such as web servers, containerized microservices, caching fleets, distributed data stores, and development environments.

- compute optimized  
are ideal for compute intensive tasks like gaming service, high performance computing, or HPC, and even scientific modeling. 

Use Cases : High-performance web servers, scientific modeling, batch processing, distributed analytics, high-performance computing (HPC), machine/deep learning, ad serving, highly scalable multiplayer gaming.

- memory optimized
Use Cases : Memory-intensive applications such as high-performance databases, distributed web-scale in-memory caches, mid-size in-memory databases, real-time big-data analytics, and other enterprise applications.

- accelerated computing
are good for floating point number calculations, graphics processing, or data pattern matching, as they use hardware accelerators.

Use Cases : 3D visualizations, graphics-intensive remote workstations, 3D rendering, application streaming, video encoding, and other server-side graphics workloads.

- storage optimized
high performance for locally stored data.

Use Cases : NoSQL databases, such as Cassandra, MongoDB, and Redis, in-memory databases, scale-out transactional databases, data warehousing, Elasticsearch, and analytics.

### name
Instance types consist of a prefix identifying the type of workloads they’re optimized for, followed by a size. For example, the instance type c5.large can be broken down into the following elements.

- c5 determines the instance family and generation number. Here, the instance belongs to the fifth generation of instances in an instance family that’s optimized for generic computation.

- large, which determines the amount of instance capacity.

## multiple billing options
https://aws.amazon.com/ec2/pricing/

- [on demand](https://aws.amazon.com/ec2/pricing/on-demand/)
pay-as-you-go pricing  
pay for the duration that your instance runs for, The price per second for a running On-Demand instance is fixed.

- [reserved instances](https://aws.amazon.com/ec2/pricing/reserved-instances/pricing/)  
workloads or ones with predictable usage.  
In the case when servers cannot be stopped, consider using a Reserved Instance to save on costs.

three payment options: All Upfront, Partial Upfront, or No Upfront. 

- [spot instances](https://aws.amazon.com/ec2/spot/pricing/)
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

- [serverless AWS Lambda](https://aws.amazon.com/serverless/#:~:text=Serverless%20is%20the%20native%20architecture,services%20without%20thinking%20about%20servers.) 
If you are looking to host short running functions, service-oriented, or event-driven applications, and you don’t want to manage the underlying environment at all, look into the serverless AWS Lambda.

https://aws.amazon.com/serverless/resources/?serverless.sort-by=item.additionalFields.createdDate&serverless.sort-order=desc

https://aws.amazon.com/lambda/serverless-architectures-learn-more/

https://aws.amazon.com/blogs/compute/best-practices-for-organizing-larger-serverless-applications/

https://docs.aws.amazon.com/lambda/latest/dg/lambda-functions.html

https://aws.amazon.com/blogs/architecture/ten-things-serverless-architects-should-know/

https://alienattack.workshop.aws/

  >Every definition of serverless mentions four aspects.  
  - No servers to provision or manage.
  - Scales with usage.
  - You never pay for idle resources.
  - Availability and fault tolerance are built-in.
  
  There are three primary components of a Lambda function: the trigger, code, and configuration.  


  https://aws.amazon.com/blogs/aws/new-for-aws-lambda-1ms-billing-granularity-adds-cost-savings/
  
  https://aws.amazon.com/blogs/compute/resize-images-on-the-fly-with-amazon-s3-aws-lambda-and-amazon-api-gateway/
  
  https://aws.amazon.com/cn/solutions/implementations/serverless-image-handler/
  
- Amazon ECS, or Amazon EKS? 
using containers makes it easier to support microservices or service-oriented designs. 

https://aws.amazon.com/containers/services/

https://www.docker.com/resources/what-container

https://aws.amazon.com/ecs/

https://github.com/aws/amazon-ecs-agent

https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_instances.html

https://www.coursera.org/learn/containerized-apps-on-aws

If you are looking to run Docker container-based workloads on AWS, you first need to choose your orchestration tool.

    Amazon EKS is conceptually similar to Amazon ECS, but there are some differences.

    - An EC2 instance with the ECS Agent installed and configured is called a container instance. In Amazon EKS, it is called a worker node.

    - An ECS Container is called a task. In the Amazon EKS ecosystem, it is called a pod.

    - While Amazon ECS runs on AWS native technology, Amazon EKS runs on top of Kubernetes.

- AWS Fargate
a serverless compute platform for ECS or EKS

>Amazon ECS and Amazon EKS enable you to run your containers in two modes.  
 Amazon EC2 mode  
 AWS Fargate mode

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

### high availability 
https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html

AWS services that are scoped at the Availability Zone level must be architected with high availability in mind.
 
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