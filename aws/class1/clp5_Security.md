# Shared Responsibility Model

# AWS Identity and Access Management
we recommend when you create your AWS account you first set up MFA for the root user, then create an IAM user with administrator permissions, log out of the root user and then log in with the new IAM user that you just created. From there, you can use this user to create the IAM groups, users and policies for the rest of the people using this AWS account.

# multi-factor authentication or MFA
 recommend them as a best practice that right after you create your AWS account, you enable multi-factor authentication or MFA for the root user.

## AWS Identity and Access Management, or IAM
https://docs.aws.amazon.com/IAM/latest/UserGuide/id.html

https://docs.aws.amazon.com/IAM/latest/UserGuide/access.html

https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

[AWS IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html) manages the login credentials and permissions to the AWS account itself and it also can manage credentials used to sign API calls made to AWS services. 

### IAM policy 
IAM users take care of the authentication and to take care of authorization, you can attach an IAM policy to a user in order to grant or deny permissions to take specific actions within an AWS account. 

## [IAM groups](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html)
An IAM group is a collection of users. All users in the group inherit the permissions assigned to the group. This makes it easy to give permissions to multiple users at once. 
- Groups can have many users.
- Users can belong to many groups.
- Groups cannot belong to groups.

## [IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
An IAM role is an identity that can be assumed by someone or something who needs temporary access to AWS credentials. 

It's very common for roles to be used for access between different AWS services. 

Maintaining roles is easier than maintaining users. When you assume a role, IAM dynamically provides temporary credentials that expire after a defined period of time, between 15 minutes and 36 hours. Users, on the other hand, have long-term credentials in the form of user name and password combinations or a set of access keys.

[AWS IAM Identity Center](https://aws.amazon.com/blogs/security/how-to-create-and-manage-users-within-aws-sso/) 
has some advantages over IAM. For example, if you’re using a third-party IdP, you can sync your users and groups to AWS IAM Identity Center.


# [AWS Organizations](https://aws.amazon.com/organizations)

## service control policies or SCPs

## Organizational Units

# Compliance
## [AWS Artifact](https://aws.amazon.com/artifact)
to gain access to compliance reports done by third parties who have validated a wide range of compliance standards.

# [AWS Shield](https://aws.amazon.com/shield)
AWS Shield is a service that protects applications against DDoS attacks. AWS Shield provides two levels of protection: Standard and Advanced.

# AWS Key Management Service (AWS KMS)

# AWS WAF
a web application firewall that lets you monitor network requests that come into your web applications. 

# [Amazon Inspector](https://aws.amazon.com/inspector/)
helps to improve the security and compliance of applications by running automated security assessments.

# Amazon GuardDuty
a service that provides intelligent threat detection for your AWS infrastructure and resources. 

