variable "eks_cluster_endpoint" {
  type = string
  description = "cluster endpoint"
  default = ""
}

variable "eks_cluster_certificate_authority_data" {
  type = string
  description = "cluster certificate authority data"
  default = ""
}

#Grafana

variable "eks_oidc_issuer_url" {
  type = string
  description = "The URL on the EKS cluster OIDC Issuer"
  default = ""
}

variable "eks_oidc_provider_arn" {
  type = string
  description = "The ARN of the OIDC Provider if enable_irsa = true"
  default = ""
}

variable "k8s_grafana_namespace" {
  type = string
  description = "k8s grafana namespace"
  default = "monitoring"
}

variable "k8s_alb_ingress_controller_namespace" {
  type = string
  description = "k8s ALB ingress controller namespace"
  default = "kube-system"
}

variable "enable_alb_ingress_controller" {
  type = bool
  description = "boolean to enable alb ingress controller"
  default = false
}

variable "cluster_version" {
  type = string
  description = "cluster version"
  default = ""
}

variable "eks_cluster_id" {
  type = string
  description = "cluster id"
  default = ""
}

variable "eks_cluster_name" {
  type = string
  description = "cluster name"
  default = ""
}

variable "node_group_name" {
  type = string
  description = "managed node group name"
  default = ""
}

variable "region" {
  type = string
  description = "region"
  default = "eu-west-1"
}

variable "azs" {
  type = list(string)
  description = "list of availability zones"
  default = []
}

# Karpenter
variable "enable_karpenter" {
  type = bool
  description = "Boolean to enable karpenter add-on"
  default = false
}

variable "managed_node_group_iam_instance_profile_id" {
  type = string
  description = "IAM instance profile id of managed node groups"
  default = ""
}

variable "worker_node_security_group_id" {
  type = string
  description = "ID of the worker node shared security group"
  default = ""
}

variable "karpenter_tag_name" {
  type = string
  description = "Tag Name for Karpenter"
  default = ""
}

variable "block_device_mappings_volume_type" {
  type = string
  description = "Volume type to assign to the instance"
  default = ""
}

variable "block_device_mappings_volume_size" {
  type = string
  description = "Size of volume type"
  default = ""
}


variable "enable_grafana" {
  type = bool
  description = "Boolean to enable grafana add-on"
  default = true
}

variable "enable_amazon_eks_vpc_cni" {
  type = bool
  default = false
}

variable "enable_amazon_eks_coredns" {
  type = bool
  default = false
}

variable "enable_amazon_eks_kube_proxy" {
  type = bool
  default = false
}

variable "enable_amazon_eks_aws_ebs_csi_driver" {
  type = bool
  default = false
}

variable "enable_argocd" {
  type = bool
  default = false
}

variable "enable_aws_for_fluentbit" {
  type = bool
  default = false
}

variable "enable_aws_load_balancer_controller" {
  type = bool
  default = true
}

variable "enable_cluster_autoscaler" {
  type = bool
  default = false
}

variable "enable_metrics_server" {
  type = bool
  default = false
}

variable "enable_prometheus" {
  type = bool
  default = false
}

variable "enable_ingress_nginx" {
  type = bool
  default = false
}

variable "enable_aws_node_termination_handler" {
  type = bool
  default = false
}

variable "enable_traefik" {
  type = bool
  default = false
}

variable "enable_agones" {
  type = bool
  default = false
}

variable "enable_spark_k8s_operator" {
  type = bool
  default = false
}

variable "enable_fargate_fluentbit" {
  type = bool
  default = false
}

variable "enable_keda" {
  type = bool
  default = false
}

variable "enable_vpa" {
  type = bool
  default = false
}

variable "enable_yunikorn" {
  type = bool
  default = false
}


