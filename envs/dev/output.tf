output "eso_role_arn" {
  description = "ARN of the External Secrets Operator IAM role"
  value       = module.iam.eso_role_arn
}

output "argocd_role_arn" {
  description = "ARN of the ArgoCD IAM role"
  value       = module.iam.argocd_role_arn
}

output "alb_controller_role_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM role"
  value       = module.iam.alb_controller_role_arn
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}
