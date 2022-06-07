data "aws_ami" "amazonlinux2eks" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-*"]
  }
  owners = ["amazon"]
}

data "aws_ami" "bottlerocket" {
  most_recent = true
  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${var.cluster_version}-x86_64-*"]
  }
  owners = ["amazon"]
}


# Creates Launch templates for Karpenter
# Launch template outputs will be used in Karpenter Provisioners yaml files. Checkout this https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/karpenter/provisioners/default_provisioner_with_launch_templates.yaml
module "karpenter_launch_templates" {
  source         = "./launch-templates"
  eks_cluster_id = var.eks_cluster_id
  tags           = { Name = var.karpenter_tag_name }

  launch_template_config = {
    linux = {
      ami                    = data.aws_ami.amazonlinux2eks.id
      launch_template_prefix = "karpenter"
      iam_instance_profile   = var.managed_node_group_iam_instance_profile_id
      vpc_security_group_ids = [var.worker_node_security_group_id]
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          volume_type = var.block_device_mappings_volume_type
          volume_size = var.block_device_mappings_volume_size
        }
      ]
    },
    bottlerocket = {
      ami                    = data.aws_ami.bottlerocket.id
      launch_template_os     = "bottlerocket"
      launch_template_prefix = "bottle"
      iam_instance_profile   = var.managed_node_group_iam_instance_profile_id
      vpc_security_group_ids = [var.worker_node_security_group_id]
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          volume_type = var.block_device_mappings_volume_type
          volume_size = var.block_device_mappings_volume_size
        }
      ]
    },
  }
}
# Deploying default provisioner for Karpenter autoscaler
data "kubectl_path_documents" "karpenter_provisioners" {
  pattern = "${path.module}/provisioners/default_provisioner.yaml"
  vars = {
    azs                     = join(",", var.azs)
    iam-instance-profile-id = format("%s-%s", var.eks_cluster_id, var.node_group_name)
    eks-cluster-id          = var.eks_cluster_id
  }
}

module "grafana" {
  source = "git::https://github.com/lablabs/terraform-aws-eks-grafana.git"

  enabled = var.enable_grafana
  cluster_identity_oidc_issuer     = var.eks_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = var.eks_oidc_provider_arn
  k8s_namespace = var.k8s_grafana_namespace

  helm_repo_url      = "https://grafana.github.io/helm-charts"
  helm_chart_version = "6.17.6"
  helm_release_name  = "grafana"

  values = yamlencode({
    "persistence" : {
      "enabled" : true
    }
  })
}

module "efs_csi_driver" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-efs-csi-driver.git"
  enabled = var.enable_efs_csi_driver
  cluster_name                     = var.eks_cluster_id
  cluster_identity_oidc_issuer     = var.eks_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = var.eks_oidc_provider_arn
}

module "alb_ingress_controller" {
  count   = var.enable_alb_ingress_controller ? 1 : 0
  source  = "iplabs/alb-ingress-controller/kubernetes"
  version = "3.4.0"

  k8s_cluster_type = "eks"
  k8s_namespace    = var.k8s_alb_ingress_controller_namespace

  aws_region_name  = var.region
  k8s_cluster_name = var.eks_cluster_id
}


module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.0.2"

  eks_cluster_id = var.eks_cluster_id

  enable_karpenter = var.enable_karpenter

  enable_amazon_eks_aws_ebs_csi_driver = var.enable_amazon_eks_aws_ebs_csi_driver
  amazon_eks_aws_ebs_csi_driver_config = {
    addon_name               = "aws-ebs-csi-driver"
    addon_version            = "v1.4.0-eksbuild.preview"
    service_account          = "ebs-csi-controller-sa"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    additional_iam_policies  = []
    service_account_role_arn = ""
    tags                     = {}
  }

  enable_ingress_nginx = var.enable_ingress_nginx
  ingress_nginx_helm_config = {
    name       = "ingress-nginx"
    chart      = "ingress-nginx"
    repository = "https://kubernetes.github.io/ingress-nginx"
    version    = "3.33.0"
    namespace  = "kube-system"
    values     = [templatefile("${path.module}/helm_values/nginx_values.yaml", {})]
  }

  enable_amazon_eks_vpc_cni = var.enable_amazon_eks_vpc_cni 
  amazon_eks_vpc_cni_config = {
    addon_name               = "vpc-cni"
    addon_version            = "v1.11.0-eksbuild.1"
    service_account          = "aws-node"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    additional_iam_policies  = []
    service_account_role_arn = ""
    tags                     = {}
  }

  enable_amazon_eks_coredns = var.enable_amazon_eks_coredns
  amazon_eks_coredns_config = {
    addon_name               = "coredns"
    addon_version            = "v1.8.4-eksbuild.1"
    service_account          = "coredns"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    service_account_role_arn = ""
    additional_iam_policies  = []
    tags                     = {}
  }

  enable_amazon_eks_kube_proxy = var.enable_amazon_eks_kube_proxy
  amazon_eks_kube_proxy_config = {
    addon_name               = "kube-proxy"
    addon_version            = "v1.21.2-eksbuild.2"
    service_account          = "kube-proxy"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    additional_iam_policies  = []
    service_account_role_arn = ""
    tags                     = {}
  }

  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller_helm_config = {
    name       = "aws-load-balancer-controller"
    chart      = "aws-load-balancer-controller"
    repository = "https://aws.github.io/eks-charts"
    version    = "2.4.1"
    namespace  = "kube-system"
  }

  enable_aws_node_termination_handler = var.enable_aws_node_termination_handler
  aws_node_termination_handler_helm_config = {
    name       = "aws-node-termination-handler"
    chart      = "aws-node-termination-handler"
    repository = "https://aws.github.io/eks-charts"
    version    = "0.16.0"
    timeout    = "1200"
  }

  enable_traefik = var.enable_traefik
  traefik_helm_config = {
    name       = "traefik"
    repository = "https://helm.traefik.io/traefik"
    chart      = "traefik"
    version    = "10.0.0"
    namespace  = "kube-system"
    timeout    = "1200"
    lint       = "true"
    set = [{
      name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
    }]
    values = [templatefile("${path.module}/helm_values/traefik-values.yaml", {
      operating_system = "linux"
    })]
  }

  enable_metrics_server = var.enable_metrics_server
  metrics_server_helm_config = {
    name       = "metrics-server"
    repository = "https://kubernetes-sigs.github.io/metrics-server/"
    chart      = "metrics-server"
    version    = "3.8.1"
    namespace  = "kube-system"
    timeout    = "1200"
    lint       = "true"
    values = [templatefile("${path.module}/helm_values/metrics-server-values.yaml", {
      operating_system = "linux"
    })]
  }

  enable_cluster_autoscaler = var.enable_cluster_autoscaler
  cluster_autoscaler_helm_config = {
    name       = "cluster-autoscaler"
    repository = "https://kubernetes.github.io/autoscaler"
    chart      = "cluster-autoscaler"
    version    = "9.10.7"
    namespace  = "kube-system"
    timeout    = "1200"
    lint       = "true"
    values = [templatefile("${path.module}/helm_values/cluster-autoscaler-vaues.yaml", {
      operating_system = "linux"
    })]
  }

  # Amazon Prometheus Configuration to integrate with Prometheus Server Add-on
  # enable_amazon_prometheus             = var.enable_prometheus
  # amazon_prometheus_workspace_endpoint = module.eks_blueprints.amazon_prometheus_workspace_endpoint

  # enable_prometheus = true
  # prometheus_helm_config = {
  #   name       = "prometheus"
  #   repository = "https://prometheus-community.github.io/helm-charts"
  #   chart      = "prometheus"
  #   version    = "15.3.0"
  #   namespace  = "prometheus"
  #   values = [templatefile("${path.module}/helm_values/prometheus-values.yaml", {
  #     operating_system = "linux"
  #   })]
  # }

  # NOTE: Agones requires a Node group in Public Subnets and enable Public IP
  # enable_agones = var.enable_agones
  # agones_helm_config = {
  #   name               = "agones"
  #   chart              = "agones"
  #   repository         = "https://agones.dev/chart/stable"
  #   version            = "1.15.0"
  #   namespace          = "kube-system"
  #   gameserver_minport = 7000 # required for sec group changes to worker nodes
  #   gameserver_maxport = 8000 # required for sec group changes to worker nodes
  #   values = [templatefile("${path.module}/helm_values/agones-values.yaml", {
  #     expose_udp            = true
  #     gameserver_namespaces = "{${join(",", ["default", "xbox-gameservers", "xbox-gameservers"])}}"
  #     gameserver_minport    = 7000
  #     gameserver_maxport    = 8000
  #   })]
  # }

  enable_aws_for_fluentbit = var.enable_aws_for_fluentbit
  aws_for_fluentbit_helm_config = {
    name                                      = "aws-for-fluent-bit"
    chart                                     = "aws-for-fluent-bit"
    repository                                = "https://aws.github.io/eks-charts"
    version                                   = "0.1.0"
    namespace                                 = "logging"
    aws_for_fluent_bit_cw_log_group           = "/${var.eks_cluster_id}/worker-fluentbit-logs" # Optional
    aws_for_fluentbit_cwlog_retention_in_days = 90
    create_namespace                          = true
    values = [templatefile("${path.module}/helm_values/aws-for-fluentbit-values.yaml", {
      region                          = var.region
      aws_for_fluent_bit_cw_log_group = "/${var.eks_cluster_id}/worker-fluentbit-logs"
    })]
    set = [
      {
        name  = "nodeSelector.kubernetes\\.io/os"
        value = "linux"
      }
    ]
  }

  enable_spark_k8s_operator = var.enable_spark_k8s_operator
  spark_k8s_operator_helm_config = {
    name             = "spark-operator"
    chart            = "spark-operator"
    repository       = "https://googlecloudplatform.github.io/spark-on-k8s-operator"
    version          = "1.1.6"
    namespace        = "spark-k8s-operator"
    timeout          = "1200"
    create_namespace = true
    values           = [templatefile("${path.module}/helm_values/spark-k8s-operator-values.yaml", {})]
  }

  enable_fargate_fluentbit = var.enable_fargate_fluentbit
  fargate_fluentbit_addon_config = {
    output_conf = <<-EOF
    [OUTPUT]
      Name cloudwatch_logs
      Match *
      region ${var.region}
      log_group_name /${var.eks_cluster_id}/fargate-fluentbit-logs
      log_stream_prefix "fargate-logs-"
      auto_create_group true
    EOF

    filters_conf = <<-EOF
    [FILTER]
      Name parser
      Match *
      Key_Name log
      Parser regex
      Preserve_Key On
      Reserve_Data On
    EOF

    parsers_conf = <<-EOF
    [PARSER]
      Name regex
      Format regex
      Regex ^(?<time>[^ ]+) (?<stream>[^ ]+) (?<logtag>[^ ]+) (?<message>.+)$
      Time_Key time
      Time_Format %Y-%m-%dT%H:%M:%S.%L%z
      Time_Keep On
      Decode_Field_As json message
    EOF
  }

  enable_argocd = var.enable_argocd
  argocd_helm_config = {
    name             = "argo-cd"
    chart            = "argo-cd"
    repository       = "https://argoproj.github.io/argo-helm"
    version          = "3.26.3"
    namespace        = "argocd"
    timeout          = "1200"
    create_namespace = true
    values           = [templatefile("${path.module}/helm_values/argocd-values.yaml", {})]
  }

  enable_keda = var.enable_keda
  keda_helm_config = {
    name       = "keda"
    repository = "https://kedacore.github.io/charts"
    chart      = "keda"
    version    = "2.6.2"
    namespace  = "keda"
    values     = [templatefile("${path.module}/helm_values/keda-values.yaml", {})]
  }

  enable_vpa = var.enable_vpa
  vpa_helm_config = {
    name       = "vpa"
    repository = "https://charts.fairwinds.com/stable"
    chart      = "vpa"
    version    = "1.0.0"
    namespace  = "vpa"
    values     = [templatefile("${path.module}/helm_values/vpa-values.yaml", {})]
  }

  enable_yunikorn = var.enable_yunikorn
  yunikorn_helm_config = {
    name       = "yunikorn"
    repository = "https://apache.github.io/yunikorn-release"
    chart      = "yunikorn"
    version    = "0.12.2"
    values     = [templatefile("${path.module}/helm_values/yunikorn-values.yaml", {})]
  }
}
