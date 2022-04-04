# Default values
locals {
  name            = "${var.default_values["project"]}-${var.default_values["environment"]}"
  cluster_version = var.default_values["version"]
  region          = data.aws_region.current.name

  tags = {
    Name     = local.name
    Project  = "${var.default_values["project"]}"
    Business = "${var.default_values["business"]}"
  }
}

# Create a kubeconfig
locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.eks.cluster_id
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.eks.cluster_id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.this.token
      }
    }]
  })

  # we have to combine the configmap created by the eks module with the externally created node group/profile sub-modules
  aws_auth_configmap_yaml = <<-EOT
  ${chomp(module.eks.aws_auth_configmap_yaml)}
      - rolearn: test
        username: test
        groups:
          - system:bootstrappers
          - system:nodes
  EOT
}