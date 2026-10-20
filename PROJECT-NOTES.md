# Project Notes

This file summarizes the demonstrated resources from the project screenshots and the uploaded project document.

- VPC name: `3tier-vpc`; CIDR: `10.0.0.0/16`
- Internet Gateway: `3tier-igw`
- NAT Gateway: `3tier-nat`
- Route tables: `public-route`, `private-route`
- Security Group: `project-sg`
- Target groups: `PUBLIC-TG`, `PRIVATE-TG`
- Load balancers: `public-application-LB`, `PRIVATE-APPLICATION-LB`
- AMIs: `public-server-ami`, `private-server-ami`
- Launch templates: `public-launch-template`, `private-launch-template`
- Auto Scaling Groups: `public-asg`, `private-asg`
- RDS identifier: `database-1`
- DB subnet group: `project-db-subnet-group`

The uploaded document's database workflow uses the writer endpoint to create/insert records and the reader endpoint to query them. Confirm actual AWS endpoints and database status in the console. Do not record real endpoint credentials or passwords here.
