> **Accuracy note:** This document combines commands recalled by the project owner, commands explicitly shown in the original project notes, and additional reference/troubleshooting commands. It does not imply every listed command was executed during the project. Review labels before using this as evidence of hands-on experience.

# Linux Commands Used in the AWS 3-Tier Architecture Project

This reference lists Linux commands relevant to the project and explains what each one does. Commands are grouped by task. Commands that change system configuration should be run only on the intended EC2 instance.

> **Note:** These are the commands documented or reasonably needed for the project workflow. The screenshots do not show every command ever typed during the sessions, so this document should not be treated as a complete shell-history export.

## 1. Update packages and install Nginx

| Command | Use |
|---|---|
| `sudo apt update` | Refreshes the package index on Ubuntu/Debian. |
| `sudo apt update -y` | Refreshes package metadata and automatically answers yes where supported. |
| `sudo apt install -y nginx` | Installs the Nginx web server. |
| `sudo systemctl start nginx` | Starts Nginx now. |
| `sudo systemctl enable nginx` | Configures Nginx to start automatically at boot. |
| `sudo systemctl enable --now nginx` | Enables and starts Nginx in one command. |
| `sudo systemctl status nginx` | Shows whether Nginx is running and recent status details. |
| `sudo systemctl --no-pager --full status nginx` | Displays the full service status without opening a pager. |
| `curl -I http://localhost` | Requests only the HTTP response headers from the local web server. |
| `curl http://localhost` | Fetches the page served locally by Nginx. |

## 2. Navigate and manage website files

| Command | Use |
|---|---|
| `pwd` | Prints the current working directory. |
| `ls` | Lists files and folders. |
| `ls -l` | Lists files with permissions, owner, size and modification time. |
| `cd /var/www/html/` | Changes to the default Nginx website directory on Ubuntu. |
| `sudo nano /var/www/html/index.html` | Opens the website file in the Nano editor with administrator permissions. |
| `sudo vi /var/www/html/index.html` | Opens the website file in the Vi editor with administrator permissions. |
| `sudo cp index.html /var/www/html/index.html` | Copies a website file into the Nginx web root (run from the directory containing the source file). |
| `sudo install -m 0644 source.html /var/www/html/index.html` | Copies a file into the web root and sets readable file permissions. |
| `sudo rm /var/www/html/index.html` | Deletes the default page; use only when you intend to replace it. |
| `cat /var/www/html/index.html` | Prints the contents of the website file. |
| `sudo chown www-data:www-data /var/www/html/index.html` | Changes the file owner and group to the standard Ubuntu web-server account. Usually not required for a static page. |
| `sudo chmod 644 /var/www/html/index.html` | Gives the owner read/write permission and other users read permission. |

## 3. Connect to EC2 and inspect the system

| Command | Use |
|---|---|
| `ssh -i key.pem ubuntu@PUBLIC_IP` | Connects to an Ubuntu EC2 instance over SSH using a private key. Replace the filename and IP with your own values. |
| `ssh -i three-tier.pem ubuntu@PRIVATE_IP` | Example of connecting to a private Ubuntu instance from a permitted jump host, if network and security-group rules allow it. |
| `chmod 400 key.pem` | Restricts the private-key file so only its owner can read it; commonly required by SSH clients. |
| `hostname` | Prints the machine hostname. |
| `hostname -I` | Prints the instance's assigned IP addresses. |
| `ip addr` | Displays network interfaces and their IP addresses. |
| `ip route` | Displays the Linux host's routing table. |
| `whoami` | Prints the current Linux username. |
| `sudo -i` | Opens an interactive root shell. Use carefully; commands run as root can modify the whole system. |
| `exit` | Exits the current shell or SSH session. |

## 4. Troubleshoot services and network connectivity

| Command | Use |
|---|---|
| `ping IP_ADDRESS` | Tests basic IP reachability when ICMP is permitted. No reply does not always mean the host is down. |
| `nc -zv IP_ADDRESS 80` | Checks whether TCP port 80 can be reached on a target host. |
| `nc -zv IP_ADDRESS 3306` | Checks whether TCP port 3306 can be reached on a target host. |
| `sudo ss -lntp` | Shows listening TCP ports and the processes using them (some process details may require sudo). |
| `sudo journalctl -u nginx --no-pager` | Shows Nginx service logs from systemd. |
| `sudo journalctl -u mysql --no-pager` | Shows MySQL service logs on a host where MySQL is installed. |
| `sudo tail -n 50 /var/log/nginx/error.log` | Shows the latest Nginx error-log lines. |
| `sudo nginx -t` | Checks Nginx configuration syntax. |
| `sudo systemctl restart nginx` | Restarts Nginx after configuration changes. |

## 5. MySQL on Ubuntu EC2 or a MySQL-compatible RDS endpoint

### Install and start a local MySQL server (only if the EC2 instance is intended to host MySQL)

| Command | Use |
|---|---|
| `sudo apt update` | Refreshes package metadata. |
| `sudo apt install -y mysql-server` | Installs MySQL Server on Ubuntu. This is different from creating an Amazon RDS database. |
| `sudo systemctl start mysql` | Starts the local MySQL service. |
| `sudo systemctl enable mysql` | Enables the local MySQL service at boot. |
| `sudo systemctl status mysql` | Checks the local MySQL service status. |
| `sudo mysql` | Opens the local MySQL client using local socket authentication when configured. |

### Connect to Amazon RDS

```bash
mysql -h YOUR_RDS_ENDPOINT -u YOUR_DB_USERNAME -p
```

- `mysql`: starts the MySQL command-line client.
- `-h`: specifies the database hostname/endpoint.
- `-u`: specifies the database username.
- `-p`: prompts for the password. Do not put the password directly in the command.

### SQL commands used to inspect and populate the example database

```sql
SHOW DATABASES;
USE mydatabase;
SHOW TABLES;
SELECT * FROM employees;
```

| SQL command | Use |
|---|---|
| `SHOW DATABASES;` | Lists databases available to the connected user. |
| `CREATE DATABASE mydatabase;` | Creates the example database, if it does not already exist and the user has permission. |
| `USE mydatabase;` | Selects `mydatabase` for subsequent statements. |
| `SHOW TABLES;` | Lists tables in the selected database. |
| `DESCRIBE employees;` | Shows the columns and data types of the `employees` table. |
| `SELECT * FROM employees;` | Reads all rows and columns from `employees`. |
| `INSERT INTO employees (name, role, salary) VALUES ('Aarav Sharma', 'Cloud Engineer', 45000.00);` | Inserts one example employee row. Repeat with the other sample rows as needed. |
| `EXIT;` | Exits the MySQL client. |

**Writer/reader note:** Use the writer endpoint for inserts and updates. Use a reader endpoint for read queries only when the selected RDS cluster/deployment provides one. Confirm the actual endpoint and permissions in the AWS console.

## 6. EBS volume expansion commands (reference)

These commands are relevant only if the project instance has an EBS partition/filesystem that needs growing. Verify the device, partition, and filesystem before running them.

| Command | Use |
|---|---|
| `lsblk` | Lists block devices, partitions and mount points. |
| `df -h` | Shows mounted filesystem usage in human-readable units. |
| `sudo growpart /dev/nvme0n1 1` | Extends partition 1 on the specified NVMe disk into available space, if supported and appropriate. |
| `sudo xfs_growfs -d /` | Grows an XFS filesystem mounted at `/` to use available space. Only use if `/` is XFS and the underlying partition/volume has already been expanded. |

## 7. Git commands for uploading this project

| Command | Use |
|---|---|
| `git --version` | Checks whether Git is installed. |
| `git init` | Initializes a local Git repository. |
| `git status` | Shows changed, staged and untracked files. |
| `git add .` | Stages current directory changes for the next commit. Review `git status` first to avoid staging secrets. |
| `git commit -m "Add AWS 3-tier architecture project"` | Creates a commit with a message. |
| `git branch -M main` | Renames the current branch to `main`. |
| `git remote add origin YOUR_REPOSITORY_URL` | Adds the GitHub repository as the remote named `origin`. |
| `git remote -v` | Lists configured Git remotes. |
| `git push -u origin main` | Pushes the `main` branch and sets its upstream remote. |
| `git log --oneline` | Shows recent commits in compact form. |

## Safety reminders

- Never commit `*.pem`, private keys, AWS access keys, passwords, or real `.env` files.
- Do not allow SSH (22) or MySQL (3306) from `0.0.0.0/0`.
- Be careful with `sudo`, `rm`, disk partition, and filesystem commands.
- Commands for local MySQL on EC2 are not the same as commands to connect to Amazon RDS.
