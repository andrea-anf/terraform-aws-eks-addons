The module allows the user to install add-ons in an EKS cluster. 

This repository has been extracted from https://github.com/aws-ia/terraform-aws-eks-blueprints.

## Usage
This is a basic usage of the module:
```tf
module "eks-addons" {
  source = "git@bitbucket.org:beetobit/terraform-aws-eks-addons.git?ref=1.0"

  region = "eu-west-1"
  azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  cluster_version = "1.21"
  eks_cluster_id = "my-cluster"
  eks_cluster_endpoint = "https://xxx.eks.amazonaws.com"
  eks_cluster_certificate_authority_data = "LS0tLS1CRUdJ=="
  node_group_name = "my-nodegroup"
  managed_node_group_iam_instance_profile_id = "my-cluster-iam-role"
  worker_node_security_group_id = "my-worker-node-security-group-id"
  block_device_mappings_volume_type = "gp3"
  block_device_mappings_volume_size = "100"
  
  ##add add-ons to enable
  enable_<addon_name> = true
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.14 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress_controller"></a> [alb\_ingress\_controller](#module\_alb\_ingress\_controller) | iplabs/alb-ingress-controller/kubernetes | 3.4.0 |
| <a name="module_eks_blueprints_kubernetes_addons"></a> [eks\_blueprints\_kubernetes\_addons](#module\_eks\_blueprints\_kubernetes\_addons) | github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons | v4.0.2 |
| <a name="module_grafana"></a> [grafana](#module\_grafana) | git@github.com:lablabs/terraform-aws-eks-grafana.git | n/a |
| <a name="module_karpenter_launch_templates"></a> [karpenter\_launch\_templates](#module\_karpenter\_launch\_templates) | ./launch-templates | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.amazonlinux2eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.bottlerocket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [kubectl_path_documents.karpenter_provisioners](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/path_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | list of availability zones | `list(string)` | `[]` | no |
| <a name="input_block_device_mappings_volume_size"></a> [block\_device\_mappings\_volume\_size](#input\_block\_device\_mappings\_volume\_size) | Size of volume type | `string` | `""` | no |
| <a name="input_block_device_mappings_volume_type"></a> [block\_device\_mappings\_volume\_type](#input\_block\_device\_mappings\_volume\_type) | Volume type to assign to the instance | `string` | `""` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | cluster version | `string` | `""` | no |
| <a name="input_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#input\_eks\_cluster\_certificate\_authority\_data) | cluster certificate authority data | `string` | `""` | no |
| <a name="input_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | cluster endpoint | `string` | `""` | no |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | cluster id | `string` | `""` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | cluster name | `string` | `""` | no |
| <a name="input_eks_oidc_issuer_url"></a> [eks\_oidc\_issuer\_url](#input\_eks\_oidc\_issuer\_url) | The URL on the EKS cluster OIDC Issuer | `string` | `""` | no |
| <a name="input_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#input\_eks\_oidc\_provider\_arn) | The ARN of the OIDC Provider if enable\_irsa = true | `string` | `""` | no |
| <a name="input_enable_agones"></a> [enable\_agones](#input\_enable\_agones) | n/a | `bool` | `false` | no |
| <a name="input_enable_alb_ingress_controller"></a> [enable\_alb\_ingress\_controller](#input\_enable\_alb\_ingress\_controller) | boolean to enable alb ingress controller | `bool` | `false` | no |
| <a name="input_enable_amazon_eks_aws_ebs_csi_driver"></a> [enable\_amazon\_eks\_aws\_ebs\_csi\_driver](#input\_enable\_amazon\_eks\_aws\_ebs\_csi\_driver) | n/a | `bool` | `false` | no |
| <a name="input_enable_amazon_eks_coredns"></a> [enable\_amazon\_eks\_coredns](#input\_enable\_amazon\_eks\_coredns) | n/a | `bool` | `false` | no |
| <a name="input_enable_amazon_eks_kube_proxy"></a> [enable\_amazon\_eks\_kube\_proxy](#input\_enable\_amazon\_eks\_kube\_proxy) | n/a | `bool` | `false` | no |
| <a name="input_enable_amazon_eks_vpc_cni"></a> [enable\_amazon\_eks\_vpc\_cni](#input\_enable\_amazon\_eks\_vpc\_cni) | n/a | `bool` | `false` | no |
| <a name="input_enable_argocd"></a> [enable\_argocd](#input\_enable\_argocd) | n/a | `bool` | `false` | no |
| <a name="input_enable_aws_for_fluentbit"></a> [enable\_aws\_for\_fluentbit](#input\_enable\_aws\_for\_fluentbit) | n/a | `bool` | `false` | no |
| <a name="input_enable_aws_load_balancer_controller"></a> [enable\_aws\_load\_balancer\_controller](#input\_enable\_aws\_load\_balancer\_controller) | n/a | `bool` | `false` | no |
| <a name="input_enable_aws_node_termination_handler"></a> [enable\_aws\_node\_termination\_handler](#input\_enable\_aws\_node\_termination\_handler) | n/a | `bool` | `false` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | n/a | `bool` | `false` | no |
| <a name="input_enable_fargate_fluentbit"></a> [enable\_fargate\_fluentbit](#input\_enable\_fargate\_fluentbit) | n/a | `bool` | `false` | no |
| <a name="input_enable_grafana"></a> [enable\_grafana](#input\_enable\_grafana) | Boolean to enable grafana add-on | `bool` | `false` | no |
| <a name="input_enable_ingress_nginx"></a> [enable\_ingress\_nginx](#input\_enable\_ingress\_nginx) | n/a | `bool` | `false` | no |
| <a name="input_enable_karpenter"></a> [enable\_karpenter](#input\_enable\_karpenter) | Boolean to enable karpenter add-on | `bool` | `false` | no |
| <a name="input_enable_keda"></a> [enable\_keda](#input\_enable\_keda) | n/a | `bool` | `false` | no |
| <a name="input_enable_metrics_server"></a> [enable\_metrics\_server](#input\_enable\_metrics\_server) | n/a | `bool` | `false` | no |
| <a name="input_enable_prometheus"></a> [enable\_prometheus](#input\_enable\_prometheus) | n/a | `bool` | `false` | no |
| <a name="input_enable_spark_k8s_operator"></a> [enable\_spark\_k8s\_operator](#input\_enable\_spark\_k8s\_operator) | n/a | `bool` | `false` | no |
| <a name="input_enable_traefik"></a> [enable\_traefik](#input\_enable\_traefik) | n/a | `bool` | `false` | no |
| <a name="input_enable_vpa"></a> [enable\_vpa](#input\_enable\_vpa) | n/a | `bool` | `false` | no |
| <a name="input_enable_yunikorn"></a> [enable\_yunikorn](#input\_enable\_yunikorn) | n/a | `bool` | `false` | no |
| <a name="input_k8s_alb_ingress_controller_namespace"></a> [k8s\_alb\_ingress\_controller\_namespace](#input\_k8s\_alb\_ingress\_controller\_namespace) | k8s ALB ingress controller namespace | `string` | `"kube-system"` | no |
| <a name="input_k8s_grafana_namespace"></a> [k8s\_grafana\_namespace](#input\_k8s\_grafana\_namespace) | k8s grafana namespace | `string` | `"monitoring"` | no |
| <a name="input_karpenter_tag_name"></a> [karpenter\_tag\_name](#input\_karpenter\_tag\_name) | Tag Name for Karpenter | `string` | `""` | no |
| <a name="input_managed_node_group_iam_instance_profile_id"></a> [managed\_node\_group\_iam\_instance\_profile\_id](#input\_managed\_node\_group\_iam\_instance\_profile\_id) | IAM instance profile id of managed node groups | `string` | `""` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | managed node group name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | region | `string` | `""` | no |
| <a name="input_worker_node_security_group_id"></a> [worker\_node\_security\_group\_id](#input\_worker\_node\_security\_group\_id) | ID of the worker node shared security group | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
