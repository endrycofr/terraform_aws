variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "repo_url" {
  type        = string
  description = "HTTPS Git URL of the application repository"
}

variable "branch" {
  type        = string
  description = "Git branch to deploy"
  default     = "main"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH (use /32 for single IP)"
  default     = "0.0.0.0/0"
}

# --- Bonus (Opsional) Self-hosted GitHub Runner ---
variable "github_repo" {
  type        = string
  description = "GitHub repo in 'owner/name' format for self-hosted runner"
  default     = ""
}

variable "github_runner_token" {
  type        = string
  description = "Short-lived GitHub Runner registration token"
  default     = ""
  sensitive   = true
}

