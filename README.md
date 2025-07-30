
<img width="1024" height="1536" alt="Diagram" src="https://github.com/user-attachments/assets/65a97022-4a9b-4c8c-80c2-533a2d74e0e9" />


🧱 Phase-by-Phase Breakdown


✅ Phase 1: Build the Flask Todo App
-Simple Python Flask app with SQLite and basic routing
-Containerized using a clean multi-stage Dockerfile
-Unit tests added using pytest

✅ Phase 2: CI/CD Pipeline with GitHub Actions
CI: Lint, format check, and unit tests on push/pull request

CD: Docker build + push to ECR and deploy to EKS

CI/CD Features:
-Secrets managed via GitHub Secrets
-Optimized for speed and reusability

✅ Phase 3: Infrastructure with Terraform
-VPC, Subnets, Internet Gateway, Route Tables
-IAM Roles for EKS Cluster, Node Group, and EBS CSI
-EKS Cluster and Managed Node Group
-EBS CSI Addon via Terraform + IRSA (IAM Role for SA)

✅ Phase 4: Deployment to EKS
-Flask app deployed via Kubernetes manifests (deployment.yaml, service.yaml)
-Namespace isolation
-ECR integration for pulling Docker images
-LoadBalancer service for public access

✅ Phase 5: Observability Stack
-Installed with Helm:
-Prometheus Operator
-Grafana Dashboards
-Loki + Promtail for logs

Port Forwarding Automation:
bash scripts/port-forward-observability.sh
Grafana: http://localhost:3000
Prometheus: http://localhost:9090
Alertmanager: http://localhost:9093


🐞 Debugging & Real-World Errors Faced
 
 This project was intentionally kept real to reflect an actual production setup. Here are real issues I faced and how I fixed them:
⚠️ 1. kubectl Not Authenticated
Error: The connection to the server localhost:8080 was refused
Fix: Ran: aws eks update-kubeconfig --name flask-todo-cluster --region eu-west-2

⚠️ 2. GitHub Actions failing to push to ECR
Error: Access denied when pushing Docker image
Fix: Made sure ECR permissions were attached to the IAM role of the node group. Also double-checked GitHub secrets for AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.

⚠️ 3. PVC Stuck in Pending State
Error:
kubectl get pvc -n monitoring
STATUS: Pending
Fix:
EBS CSI driver was not installed correctly.
-Installed via eksctl create addon and later rewrote via Terraform with correct OIDC IRSA role for the SA ebs-csi-controller-sa.
-Confirmed with kubectl get sc showing provisioner kubernetes.io/aws-ebs.


⚠️ 4. Cluster Region Mismatch
Error: No cluster found for name: flask-todo-cluster
Cause: Multiple clusters in different regions. GitHub Actions and kubectl were referencing different regions.
Fix: Explicitly set region using aws configure and in Terraform provider block.

⚠️ 5. EKS Node Group Failed After Cluster Creation
Error: EKS cluster was up but nodes were in NotReady state.
Cause: IAM role for Node Group missing correct policies (CNI, WorkerNode, ECR)
Fix: Attached below the required policies via Terraform:
aws_iam_role_policy_attachment.eks_worker_node_policy
aws_iam_role_policy_attachment.eks_cni_policy
aws_iam_role_policy_attachment.ecr_readonly


🧪 Testing Observability Locally
After deploying:
bash scripts/port-forward-observability.sh
View Grafana Dashboards: http://localhost:3000
Credentials: admin: xxxxx /passward: xxxx


🧠 Lessons Learned
🔁 Real world DevOps pipelines are iterative expect when things to fail and debug.
🛡️ IRSA and IAM permissions must be crystal clear for secure and working deployments.
🌍 Region mismatch is a common error when automating infra.
🔍 Observability should be prioritised early  not just at the end.

🗺️ Next Steps
-Integrate ArgoCD for GitOps-style continuous deployment
-Add PostgreSQL via RDS module
-Auto-scale node group using Cluster Autoscaler
