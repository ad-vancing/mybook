# instance storage volumes
An instance store provides temporary block-level storage for an Amazon EC2 instance.  
When you launch an EC2 instance, depending on the type of the EC2 instance you launched, it might provide you with local storage called **instance store volumes**.

if you stop or terminate your EC2 instance, all data written to the instance store volume will be deleted.

useful in situations where you may lose the data that is written to the drive, such as temporary files, scratch data, and data that can be easily recreated without consequence.

#  Amazon Elastic Block Store, or EBS
With EBS, you can create virtual hard drives that we call EBS volumes that you can attach to your EC2 instances.

an EBS volume can persist between stops and starts of an EC2 instance.

In order to attach EC2 to EBS, you need to be **in the same AZ**, you can save files on it, you can also run a database on top of it or store applications on it. It's a hard drive.

EBS allows you to take incremental backups of your data called snapshots. if a drive ever becomes corrupted, you haven't lost your data and you can restore that data from a snapshot.

# Amazon Simple Storage Service (Amazon S3)
 a service that provides object-level storage. Amazon S3 stores data as objects in buckets.
>Object Storage  
**In object storage, each object consists of data, metadata, and a key**.

S3 is already web-enabled. Every object already has a URL that you can control access rights to who can see or manage the image. It's regionally distributed, which means that it has 11 9's of durability. No need to worry about backup strategies. 

The maximum file size for an object in Amazon S3 is 5 TB.

## Amazon S3 Storage Classes
- Amazon S3 Standard
    - Designed for **frequently accessed data but requires high availability when needed**
    - Stores data**in a minimum of three Availability Zones**
    - has a higher cost than other storage classes intended for infrequently accessed data and archival storage.
- Amazon S3 Standard-Infrequent Access (S3 Standard-IA)
    - Ideal for **infrequently accessed data**    
    - Stores data**in a minimum of three Availability Zones**
    -  has a lower storage price and higher retrieval price
- Amazon S3 One Zone-Infrequent Access (S3 One Zone-IA)
    - Stores data**in a single Availability Zone**
    -  a lower storage price
- Amazon S3 Intelligent-Tiering
. If you haven’t accessed an object for 30 consecutive days, Amazon S3 automatically **moves it to the infrequent access tier**, Amazon S3 Standard-IA. If you access an object in the infrequent access tier, Amazon S3 automatically **moves it to the frequent access tier**, Amazon S3 Standard.
- Amazon S3 Glacier Instant Retrieval
for archived data that requires immediate access
- Amazon S3 Glacier Flexible Retrieval
Low-cost storage designed for data archiving
- Amazon S3 Glacier Deep Archive
Lowest-cost object storage class ideal for archiving
- Amazon S3 Outposts
Amazon S3 Outposts delivers object storage to your on-premises AWS Outposts environment.    
        
# Amazon Elastic File System, EFS
It is a true file system for Linux. It is also a **regional resource**, meaning any EC2 instance in the region can write to EFS file system. As you write more data to EFS, it automatically scales. No need to provision anymore volumes.

Compared to block storage and object storage, file storage is ideal for use cases in which a large number of services and resources need to access the same data at the same time.
