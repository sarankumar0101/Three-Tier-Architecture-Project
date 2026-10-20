# Architecture Notes

![AWS 3-Tier Architecture](docs/architecture.png)

## Three tiers

1. **Presentation / public web tier** — an internet-facing Application Load Balancer sends HTTP requests to public EC2 instances running Nginx.
2. **Application / private tier** — an internal Application Load Balancer routes traffic to private EC2 targets.
3. **Data tier** — Amazon RDS for MySQL stores application data in private database subnets.

## Network

VPC CIDR: `10.0.0.0/16`

| Subnet | CIDR | Intended use |
|---|---|---|
| public-1 | 10.0.1.0/24 | Public web resources |
| public-2 | 10.0.2.0/24 | Public web resources |
| private-1 | 10.0.3.0/24 | Private application resources |
| private-2 | 10.0.4.0/24 | Private application resources |
| db-1 | 10.0.5.0/24 | Database subnet group |
| db-2 | 10.0.6.0/24 | Database subnet group |
| db-subnet-3 | 10.0.7.0/24 | Database subnet group coverage |

Public route table: route internet-bound traffic (`0.0.0.0/0`) to the Internet Gateway. Private route table: route internet-bound outbound traffic to the NAT Gateway when required. Confirm route table associations in the AWS console.

## Load balancing and scaling

- `public-application-LB` is internet-facing and forwards to `PUBLIC-TG`.
- `PRIVATE-APPLICATION-LB` is internal and forwards to `PRIVATE-TG`.
- Target groups use HTTP on port 80.
- `public-asg` uses `public-launch-template`.
- `private-asg` uses `private-launch-template`.
- The project screenshots showed desired capacity 2, minimum 2 and maximum 3 for each Auto Scaling Group. Verify current settings in AWS.

## Database workflow

Use the RDS writer endpoint for inserts/updates and the configured reader endpoint for read-only queries. Endpoint availability depends on the actual RDS deployment configuration. Do not put database credentials in this repository.
