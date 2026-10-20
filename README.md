# AWS 3-Tier Architecture Project

A learning project demonstrating a three-tier architecture on AWS using a VPC, public/private subnets, EC2, Nginx, Application Load Balancers, Target Groups, Auto Scaling Groups, and Amazon RDS for MySQL.

## Architecture diagram

![AWS 3-Tier Architecture](docs/architecture.png)

## Architecture flow

`Internet → Internet-facing ALB → Public EC2 web tier → Internal ALB → Private EC2 application tier → Amazon RDS for MySQL`

The public ALB and sample pages demonstrate load balancing across the public web instances. The private ALB routes requests to private-tier targets. The database is intended to remain private.

## AWS resources represented

- VPC: `3tier-vpc` (`10.0.0.0/16`)
- Subnets:
  - `public-1` — `10.0.1.0/24`
  - `public-2` — `10.0.2.0/24`
  - `private-1` — `10.0.3.0/24`
  - `private-2` — `10.0.4.0/24`
  - `db-1` — `10.0.5.0/24`
  - `db-2` — `10.0.6.0/24`
  - `db-subnet-3` — `10.0.7.0/24`
- Internet Gateway: `3tier-igw`
- NAT Gateway: `3tier-nat`
- Route tables: `public-route`, `private-route`
- Security Group: `project-sg`
- EC2: two public and two private application instances
- Load balancers: `public-application-LB` (internet-facing), `PRIVATE-APPLICATION-LB` (internal)
- Target groups: `PUBLIC-TG`, `PRIVATE-TG` (HTTP, port 80)
- AMIs: `public-server-ami`, `private-server-ami`
- Launch templates: `public-launch-template`, `private-launch-template`
- Auto Scaling Groups: `public-asg`, `private-asg`
- RDS DB identifier shown in the console: `database-1`
- DB subnet group: `project-db-subnet-group`

Resource names and availability may change. Check the AWS console before using these names or assumptions.

## Repository structure

```text
aws-3-tier-architecture/
├── README.md
├── .gitignore
├── LICENSE
├── ARCHITECTURE.md
├── LINUX-COMMANDS-AND-USES.md
├── website/
│   ├── public-server-1/index.html
│   └── public-server-2/index.html
├── scripts/
│   ├── install-nginx-ubuntu.sh
│   ├── deploy-public-server-1.sh
│   └── deploy-public-server-2.sh
└── docs/
    ├── architecture.png
    └── PROJECT-NOTES.md
```

## Website deployment on Ubuntu EC2

Connect to each intended public EC2 instance using SSH or EC2 Instance Connect. Copy the relevant `index.html` into `/var/www/html/` and ensure Nginx is installed and running.

Example commands on an Ubuntu instance:

```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl enable --now nginx
```

Copy the desired page into `/var/www/html/index.html`, then test locally:

```bash
curl -I http://localhost
```

The provided deploy scripts are examples and assume the repository is present on the EC2 instance. Review them before use.

## Database guidance

The attached project notes describe using the RDS writer endpoint to create/insert data and the reader endpoint to query it. Keep the RDS database private and allow TCP 3306 only from the application tier or a controlled administration host. A reader endpoint is available only when supported by the selected RDS deployment/cluster configuration; confirm the actual endpoint shown by AWS.

## Security

- Do not commit `.pem` private keys, passwords, database credentials, access keys, or `.env` files.
- Do not expose SSH (TCP 22) or MySQL (TCP 3306) to `0.0.0.0/0`.
- Keep the database in private subnets.
- Prefer least-privilege IAM roles and security-group references.
- Never paste real secrets into README, scripts, screenshots, or Git history.

## Cost reminder

EC2, RDS, load balancers, NAT Gateways, and public IPv4 addresses can incur charges. Review the AWS Billing console and stop/delete resources you no longer need.

## Git commands

Run these from the project directory:

```bash
git init
git add .
git status
git commit -m "Add AWS 3-tier architecture project"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

Replace the remote URL with your own GitHub repository URL. Do not commit private keys or credentials.

## Project evidence and screenshots

The `screenshots/` folder contains the original screenshots supplied for this project, including VPC/subnet configuration, gateways, EC2 instances, load balancers, target groups, Auto Scaling, launch templates, AMIs, RDS and MySQL query results.

See the [Screenshot Gallery](docs/SCREENSHOTS.md) for captions and an ordered gallery. The original written project document is preserved at [`docs/original-project-document.pdf`](docs/original-project-document.pdf).

## Linux commands and troubleshooting

See [`LINUX-COMMANDS-AND-USES.md`](LINUX-COMMANDS-AND-USES.md). Commands are labeled or described as confirmed, recalled, or reference examples where possible; do not claim that a reference command was run unless you actually ran it.

## Important accuracy and security notes

- The screenshots document configuration and selected tests; they do not alone prove every component is production-ready or that a live website is fully integrated with RDS.
- Review and redact AWS account IDs, public IP addresses, resource identifiers, DNS endpoints and other details before making the repository public.
- Never commit `.pem` private keys, AWS credentials, database passwords, tokens, or `.env` files.
- Do not store SSH private keys in `/var/www/html/` or any public web root.
- AWS resources such as NAT Gateways, load balancers, EC2 and RDS can incur charges. Check billing and stop/delete resources you no longer need.
