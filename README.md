Automated Dockerized Web Application Deployment
This project demonstrates the automation of a Dockerized web application deployment using modern DevOps tools. The workflow includes provisioning cloud infrastructure, configuring servers, containerizing the application, and implementing a CI/CD pipeline using Terraform, Docker, SSH, and GitHub Actions.

Project Overview
The project automates the deployment of a sample web application hosted on an Nginx server. The application is containerized using Docker and deployed on an Azure virtual machine (VM). The infrastructure is provisioned using Terraform, and the CI/CD pipeline is implemented using GitHub Actions.

Features
Infrastructure as Code (IaC): Terraform scripts automate the provisioning of Azure resources (VM, network, security groups).
Docker Containerization: The application is packaged into a Docker container for portability and consistency.
CI/CD Pipeline: GitHub Actions automates the build, test, and deployment process.
SSH Configuration: Manual server configuration ensures Docker is installed and ready for deployment.
Technologies Used
Terraform: For provisioning Azure infrastructure.
Docker: For containerizing the web application.
GitHub Actions: For automating the CI/CD pipeline.
Azure: For hosting the virtual machine and application.
SSH: For server configuration and deployment.
