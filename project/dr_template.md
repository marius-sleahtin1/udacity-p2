# Infrastructure

## AWS Zones
We are using the following AWS zones:
1. us-east-2 (Ohio) with 2 AZS - us-east-2a and us-east-2b
2. us-west-1 (California) with 2 usable AZS - us-west-1b and us-west-1c

## Servers and Clusters

### Table 1.1 Summary
| **Asset**             | **Purpose**               | **Size**                                        | **Qty** | **DR**                                                                                                                                                                                              |
|-----------------------|---------------------------|-------------------------------------------------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **VPC**               | Local network in AWS      | N/A                                             | 2       | We maintain two VPCs, one situated in us-east-1 and the other in us-west-1, ensuring redundancy in case of failure in either location.                                                              |
| **EC2 VM**            | Compute resources         | t3.micro                                        | 6       | This asset will be created across two regions: three VMs within one VPC and another three VMs within the second VPC, with each VM residing in a distinct availability zone for regional redundancy. |
| **EKS Cluster**       | Containerised environment | N/A - contains EC2 as compute power (t3.medium) | 2       | The EKS cluster will contain two nodes to ensure internal resilience, with one EKS cluster provisioned in each region.                                                                              |
| **ALB**               | Entrypoint in the AWS     | N/A                                             | 2       | Each region will feature a redundant ALB, ensuring continuity in case of a failure in one region.                                                                                                   |
| **SQL cluster (RDS)** | Database                  | N/A                                             | 4       | We'll establish two clusters, each comprising two instances.                                                                                                                                        |


### Descriptions
VPC - Functions as the local network in AWS where we can generate essential resources.
EC2 VM - Represents an AWS Virtual Machine, providing computational capabilities for the applications we plan to deploy.
EKS Cluster - Serves as AWS's Container Orchestrator, acting as the computing platform for containerized applications.
ALB - Stands for AWS Application Load Balancer, serving as an entry point for applications deployed in EKS/EC2.
SQL Cluster - Functions as the database storing various data for the deployed applications.

## DR Plan
### Pre-Steps:
1.Establish the VPC within the secondary region.
2.Set up the EKS Cluster, incorporating nodegroups housing EC2 instances, and create EC2 instances if necessary.
3.Deploy the RDS cluster.
4.Validate that the infrastructure operates as intended.

## Steps:
Setting up a cloud load balancer enables consolidating multiple instances behind a single IP within a region. By directing DNS to this load balancer, you establish a more robust approach. In case of a failover, simply switching the single DNS entry at your DNS provider to the Disaster Recovery (DR) site proves to be a smarter choice than relying on a single web server instance.Additionally, maintaining a replicated database ensures resilience. While backups are crucial, restoring from them can be time-consuming. With a pre-configured replicated database, executing a database failover during a DR scenario becomes a smooth process. Ideally, your application would utilize a generic CNAME DNS record, effortlessly connecting to the DR database instance.