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

variable "eks_cluster_id" {
  type = string
  description = "cluster id"
  default = ""
}

variable "region" {
  type = string
  description = "region"
  default = "eu-west-1"
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


