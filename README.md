# Azure AKS Private Cluster - Terraform Infrastructure

Production-ready Terraform code to deploy private Azure Kubernetes Service (AKS) clusters with enterprise-grade security and compliance features.

## 🏗️ What This Deploys

This Terraform configuration creates:

- ✅ **Private AKS Management Cluster** (3 nodes with autoscaling)
- ✅ **Virtual Network** with dedicated subnets
- ✅ **Private DNS Zone** for secure API server access
- ✅ **Network Security Groups** for subnet isolation
- ✅ **Log Analytics Workspace** for monitoring
- ✅ **System-assigned Managed Identity**
- ✅ **Azure Policy** integration
- ✅ **Container Insights** monitoring

**Total Resources Created**: ~15 Azure resources  
**Estimated Monthly Cost**: £205-225 (UK South region)

---

## 📋 Prerequisites

Before you begin, ensure you have:

### 1. Required Tools
```bash
# Azure CLI (version 2.30.0 or higher)
az --version

# Terraform (version 1.5.0 or higher)
terraform --version

# Git
git --version
```

### 2. Azure Subscription

- Active Azure subscription
- Contributor role or higher
- Network Contributor role for VNet operations

### 3. Azure Authentication
```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account list --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify current subscription
az account show
```

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/aks-private-terraform.git
cd aks-private-terraform/terraform
```

### Step 2: Configure Your Variables
```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

**Minimum required changes in `terraform.tfvars`:**
```hcl
resource_group_name     = "rg-aks-myproject-dev"
location                = "UK South"
management_cluster_name = "aks-myproject-mgmt-dev"

tags = {
  Environment = "dev"
  Project     = "MyProject"
  Owner       = "your-name@company.com"
}
```

### Step 3: Initialize Terraform
```bash
terraform init
```

**Expected output:**
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 3.80"...
- Installing hashicorp/azurerm v3.xx.x...
Terraform has been successfully initialized!
```

### Step 4: Plan the Deployment
```bash
terraform plan -out=tfplan
```

**Review the plan carefully:**
- Should show ~15 resources to be created
- Check resource names match your naming convention
- Verify no unexpected deletions

### Step 5: Deploy Infrastructure
```bash
terraform apply tfplan
```

**Deployment time**: 10-15 minutes

**What happens during deployment:**
1. Creates resource group and networking (1-2 min)
2. Creates private DNS zone (30 sec)
3. Creates AKS cluster and node pools (8-12 min)
4. Configures monitoring and role assignments (1-2 min)

### Step 6: Verify Deployment
```bash
# Check cluster status
az aks show \
  --resource-group rg-aks-myproject-dev \
  --name aks-myproject-mgmt-dev \
  --query "powerState.code" \
  -o tsv

# Should output: Running
```

---

## 🔐 Accessing Your Private Cluster

Since this is a **private cluster**, the API server has no public IP. You need to access it from within the VNet.

### Option 1: Create a Jump Box VM
```bash
# Create a small VM in the management subnet
az vm create \
  --resource-group rg-aks-myproject-dev \
  --name vm-jumpbox \
  --image Ubuntu2204 \
  --size Standard_B2s \
  --vnet-name vnet-aks-private \
  --subnet snet-aks-management \
  --admin-username azureuser \
  --generate-ssh-keys

# SSH to the VM
ssh azureuser@<VM_PUBLIC_IP>

# Inside the VM, install Azure CLI and kubectl
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo az aks install-cli

# Get cluster credentials
az login
az aks get-credentials \
  --resource-group rg-aks-myproject-dev \
  --name aks-myproject-mgmt-dev

# Test access
kubectl get nodes
kubectl get pods -A
```

### Option 2: Use Azure Bastion (Recommended for Production)
```bash
# Deploy Azure Bastion (one-time setup)
az network bastion create \
  --resource-group rg-aks-myproject-dev \
  --name bastion-aks \
  --vnet-name vnet-aks-private \
  --location "UK South" \
  --sku Basic

# Then connect via Azure Portal to your jump box
```

### Option 3: VPN/ExpressRoute

If you have VPN or ExpressRoute connected to your Azure VNet:
```bash
# From your local machine (connected via VPN)
az aks get-credentials \
  --resource-group rg-aks-myproject-dev \
  --name aks-myproject-mgmt-dev

kubectl get nodes
```

---

## 📁 Project Structure
```
aks-private-terraform/
├── README.md                    # This file
├── .gitignore                   # Git ignore rules
├── terraform/
│   ├── versions.tf              # Terraform & provider versions
│   ├── providers.tf             # Azure provider configuration
│   ├── variables.tf             # Input variable definitions
│   ├── terraform.tfvars         # Example variable values
│   ├── network.tf               # VNet, subnets, NSGs
│   ├── private-dns.tf           # Private DNS zone setup
│   ├── aks-management.tf        # AKS cluster configuration
│   └── outputs.tf               # Output values
└── docs/
    ├── ARCHITECTURE.md          # Architecture documentation
    └── TROUBLESHOOTING.md       # Common issues and solutions
```

---

## 🔧 Configuration Reference

### Key Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `resource_group_name` | Resource group name | `rg-aks-private` | Yes |
| `location` | Azure region | `UK South` | Yes |
| `vnet_address_space` | VNet CIDR block | `["10.0.0.0/16"]` | No |
| `management_subnet_prefix` | Management subnet CIDR | `["10.0.1.0/24"]` | No |
| `management_cluster_name` | AKS cluster name | `aks-management` | Yes |
| `kubernetes_version` | Kubernetes version | `1.29` | No |
| `management_node_count` | Initial node count | `3` | No |
| `management_vm_size` | VM size for nodes | `Standard_D2s_v3` | No |

### Network Architecture
```
VNet: 10.0.0.0/16
├── Management Subnet: 10.0.1.0/24 (AKS Management Cluster)
└── Runtime Subnet: 10.0.2.0/24 (Reserved for future use)
```

### AKS Cluster Specifications

- **Node Count**: 3 (autoscaling enabled: min 2, max 5)
- **VM Size**: Standard_D2s_v3 (2 vCPU, 8 GB RAM)
- **OS Disk**: 128 GB Managed Disk
- **Network Plugin**: Azure CNI
- **Network Policy**: Azure Network Policy
- **Load Balancer**: Standard SKU
- **Private Cluster**: Enabled (no public API endpoint)

---

## 📊 Outputs

After successful deployment, retrieve outputs:
```bash
# View all outputs
terraform output

# Get specific output
terraform output management_cluster_name
terraform output management_cluster_private_fqdn

# Get kubeconfig (sensitive)
terraform output -raw kube_config_raw > ~/.kube/config
```

**Available Outputs:**
- Resource group name
- VNet name and ID
- Subnet IDs
- Cluster name and ID
- Private FQDN
- Log Analytics workspace ID
- Managed identity principal ID

---

## 💰 Cost Breakdown

**Estimated monthly costs (UK South region):**

| Resource | Quantity | Unit Cost | Monthly Cost |
|----------|----------|-----------|--------------|
| Standard_D2s_v3 VMs | 3 nodes | ~£55 | ~£165 |
| Managed Disks (128 GB) | 3 disks | ~£5 | ~£15 |
| Standard Load Balancer | 1 | ~£15 | ~£15 |
| Log Analytics | 1 workspace | ~£10-30 | ~£10-30 |
| **Total** | | | **~£205-225** |

### Cost Optimization Tips

1. **Use Reserved Instances**: Save up to 60% on compute
2. **Right-size VMs**: Monitor usage and adjust VM size
3. **Enable Autoscaling**: Already configured (scales down to 2 nodes)
4. **Use Spot Nodes**: For non-critical workloads (future enhancement)

---

## 🔄 Common Operations

### Scale the Cluster
```bash
# Scale manually
az aks scale \
  --resource-group rg-aks-myproject-dev \
  --name aks-myproject-mgmt-dev \
  --node-count 5

# Or update terraform.tfvars and apply
# management_node_count = 5
terraform apply
```

### Upgrade Kubernetes Version
```bash
# Check available versions
az aks get-upgrades \
  --resource-group rg-aks-myproject-dev \
  --name aks-myproject-mgmt-dev \
  -o table

# Update terraform.tfvars
# kubernetes_version = "1.30"

# Apply upgrade
terraform apply
```

### View Cluster Logs
```bash
# Get cluster credentials
az aks get-credentials \
  --resource-group rg-aks-myproject-dev \
  --name aks-myproject-mgmt-dev

# View node logs
kubectl logs -n kube-system -l component=kube-apiserver

# Check cluster events
kubectl get events -A --sort-by='.lastTimestamp'
```

---

## 🛠️ Troubleshooting

### Issue: Cannot access the cluster

**Symptoms**: `Unable to connect to the server`

**Solution**: 
- You must be inside the VNet or connected via VPN
- Create a jump box VM in the management subnet
- Or use Azure Bastion for secure access
```bash
# Verify private FQDN
az aks show \
  --resource-group rg-aks-myproject-dev \
  --name aks-myproject-mgmt-dev \
  --query "privateFqdn" -o tsv
```

### Issue: Nodes not starting

**Symptoms**: Nodes show "NotReady" status

**Solution**:
- Wait 5-10 minutes after deployment
- Check NSG rules aren't blocking traffic
- Verify subnet has available IPs
```bash
# Check node status
kubectl get nodes

# Check node events
kubectl describe node <node-name>
```

### Issue: Terraform apply fails

**Symptoms**: Error creating resources

**Common causes**:
1. Insufficient Azure permissions
2. Quota limits reached
3. DNS zone naming issues
4. Region capacity

**Solution**:
```bash
# Check your permissions
az role assignment list \
  --assignee $(az ad signed-in-user show --query id -o tsv)

# Check quotas
az vm list-usage --location "UK South" -o table
```

For more troubleshooting, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 🔒 Security Features

- ✅ **Private API Server**: No public endpoint
- ✅ **Azure CNI Networking**: Direct pod IP assignment
- ✅ **Network Policies**: Pod-to-pod security
- ✅ **Private DNS**: Internal name resolution
- ✅ **Managed Identity**: No credential management
- ✅ **Azure Policy**: Compliance enforcement
- ✅ **Container Insights**: Real-time monitoring
- ✅ **NSG Rules**: Subnet-level security

---

## 🧹 Cleanup

**Warning**: This will delete all resources and cannot be undone!
```bash
# Review what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy

# Confirm by typing: yes
```

**Manual cleanup (if terraform destroy fails):**
```bash
# Delete resource group (deletes all resources inside)
az group delete \
  --name rg-aks-myproject-dev \
  --yes \
  --no-wait
```

---

## 📚 Additional Documentation

- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Detailed architecture and design decisions
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Azure AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/)

---

## 🚧 Roadmap

### Phase 1: Management Cluster ✅
- [x] Private AKS cluster
- [x] Virtual network setup
- [x] Private DNS zone
- [x] Monitoring and logging

### Phase 2: Runtime Cluster (Next)
- [ ] Deploy runtime AKS cluster
- [ ] Configure cluster peering
- [ ] Set up ingress controller

### Phase 3: Enhanced Security
- [ ] Azure Container Registry with private endpoint
- [ ] Azure Key Vault with private endpoint
- [ ] Azure Firewall for egress control
- [ ] Pod Identity / Workload Identity

### Phase 4: GitOps & Automation
- [ ] ArgoCD / Flux deployment
- [ ] CI/CD pipeline integration
- [ ] Automated backup with Velero

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👤 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)

---

## ⭐ Support

If this project helped you, please give it a ⭐ star!

For issues or questions, please open an issue on GitHub.

---

## 📌 Quick Reference
```bash
# Initialize
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Plan deployment
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Show current state
terraform show

# List resources
terraform state list

# View outputs
terraform output

# Destroy everything
terraform destroy
```

---

**Last Updated**: November 2024  
**Terraform Version**: >= 1.5.0  
**Azure Provider Version**: ~> 3.80
