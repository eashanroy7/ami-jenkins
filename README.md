# Jenkins AMI with Packer

Enterprise-grade Jenkins automation platform built with Infrastructure as Code principles. This project implements a fully automated Jenkins AMI using Packer and GitHub Actions, featuring Jenkins Configuration as Code (JCasC) for zero-touch provisioning, Caddy reverse proxy with automated SSL, and pre-configured CI/CD pipelines for Docker multi-arch builds, Helm chart releases with semantic versioning, and conventional commit enforcement.

## 🚀 Features

### Infrastructure Automation
- **Immutable Infrastructure**: Custom AMI built with Packer for consistent, reproducible deployments
- **Zero-Touch Provisioning**: Jenkins fully configured via Configuration as Code (JCasC)
- **Automated SSL**: Caddy reverse proxy with Let's Encrypt certificate automation
- **CI/CD Integration**: Automated AMI builds via GitHub Actions with format validation

### Pre-configured DevOps Toolchain
The AMI includes a comprehensive set of tools for modern DevOps workflows:
- **Jenkins** with 39+ pre-installed plugins (Docker, GitHub, Job DSL, etc.)
- **Docker** with Buildx support for multi-architecture image builds
- **Helm** for Kubernetes package management
- **Terraform** for infrastructure provisioning
- **Node.js 20** with semantic-release tooling for automated versioning
- **GitHub CLI** for repository automation
- **Maven** for Java builds

### Pre-configured Jenkins Pipelines
Three production-ready pipeline templates included:
1. **Conventional Commit Linter**: Enforces commit message standards for better changelog generation
2. **Multi-Arch Docker Builder**: Builds and pushes Docker images for AMD64 and ARM64 platforms
3. **Helm Semantic Release**: Automated Helm chart versioning and publishing with multibranch pipeline support

## 🏗️ Architecture

### Base Configuration
- **OS**: Ubuntu 24.04 LTS
- **Instance Type**: t2.medium (configurable)
- **Storage**: 50GB GP2 EBS volume
- **Region**: us-east-1 (configurable)

### Security & Best Practices
- Credentials managed securely through JCasC with placeholder replacement
- Non-interactive installations for true automation
- Docker socket permissions configured for Jenkins user
- Setup wizard disabled for fully automated configuration

## 📦 What Gets Built

The Packer template creates an AMI with:
- Jenkins service running and configured
- All plugins pre-installed and owned by Jenkins user
- Configuration as Code YAML applied at startup
- Job DSL scripts for pipeline creation
- Caddy configured as HTTPS reverse proxy
- Complete DevOps toolchain installed and ready

## 🛠️ Usage

### Prerequisites
- AWS account with appropriate IAM permissions
- Packer installed locally
- AWS credentials configured

### Packer Commands

```bash
# Initialize Packer plugins
packer init packer/template/jenkins-ami-template.pkr.hcl

# Format the template
packer fmt packer/template/jenkins-ami-template.pkr.hcl

# Validate the configuration
packer validate packer/template/jenkins-ami-template.pkr.hcl

# Build the AMI
packer build packer/template/jenkins-ami-template.pkr.hcl
```

### Configuration Variables

Key variables that can be customized:
- `aws_region`: Target AWS region (default: us-east-1)
- `instance_type`: EC2 instance type (default: t2.medium)
- `volume_size`: EBS volume size in GB (default: 50)
- `ami_users`: List of AWS account IDs to share the AMI with
- `subnet_id`: VPC subnet for the build instance

## 🔧 Customization

### Jenkins Configuration
Edit `jenkins/jenkins-config-as-code.yaml` to:
- Modify system settings and executors
- Add/remove credentials
- Configure security realms and authorization
- Add additional Job DSL scripts

### Plugin Management
Update `jenkins/plugins-list.txt` to add or remove Jenkins plugins. The plugin manager will install all dependencies automatically.

### Pipeline Templates
Customize or add new pipelines by creating Groovy DSL files in the `jenkins/` directory and referencing them in the JCasC YAML.

## 📋 Pipeline Details

### Conventional Commit Linter
Validates PR commit messages against the Conventional Commits specification:
- Supported types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `revert`, `ci`, `build`
- Enforces format: `type(scope): description`
- Blocks PRs with non-compliant commits

### Multi-Arch Docker Builder
- Builds Docker images for AMD64 and ARM64 architectures
- Pushes to Docker Hub with authentication
- Triggered by GitHub push events

### Helm Semantic Release
- Multibranch pipeline for Helm chart repositories
- Automated semantic versioning based on commit messages
- Builds PRs and origin branches

## 🚦 CI/CD Pipeline

The AMI itself is built through a GitHub Actions workflow that:
1. Validates Packer template formatting
2. Runs Packer validate
3. Builds the AMI in AWS
4. Tags and versions the AMI with timestamps

## 💡 Use Cases

- **Rapid Jenkins Deployment**: Launch production-ready Jenkins instances in minutes
- **Disaster Recovery**: Quick recovery with pre-configured AMIs
- **Multi-Environment Consistency**: Same Jenkins configuration across dev/staging/prod
- **Team Onboarding**: Standardized CI/CD platform for new projects
- **Kubernetes CI/CD**: Pre-configured for Helm chart and container workflows

## 🔐 Security Notes

- Admin credentials are placeholders that should be replaced via GitHub Secrets or Parameter Store
- Caddy is configured for Let's Encrypt staging by default (change for production)
- Docker socket permissions are set to 666 for Jenkins access (consider rootless Docker for production)
- Ensure IAM roles follow principle of least privilege

## 📚 Technologies Used

- **Packer** - Automated machine image creation
- **Jenkins** - CI/CD automation server
- **Caddy** - Modern web server with automatic HTTPS
- **Docker** - Container runtime and build tool
- **Helm** - Kubernetes package manager
- **Terraform** - Infrastructure provisioning
- **GitHub Actions** - CI/CD pipeline for AMI builds
- **JCasC** - Jenkins Configuration as Code

## 🎯 Future Enhancements

- [ ] Add monitoring and logging (Prometheus, Grafana, CloudWatch)
- [ ] Implement Jenkins agents for distributed builds
- [ ] Add integration tests for built AMI
- [ ] Support for multiple cloud providers (Azure, GCP)
- [ ] Backup and restore automation for Jenkins_home

---

*Built with Infrastructure as Code principles for modern DevOps workflows*
