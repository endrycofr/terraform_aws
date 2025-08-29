region              = "us-west-2"                     # Region AWS yang ingin digunakan
instance_type       = "t3.micro"                            # Ukuran EC2
repo_url            = "https://github.com/endrycofr/terraform_aws.git"  # URL repo Anda
branch              = "main"                                # Branch untuk di-deploy
allowed_ssh_cidr    = "203.0.113.5/32"                     # Ganti dengan IP Anda sendiri
# Bonus (opsional)
# github_repo         = "endrycofr/terraform_aws"                     # ex: endrycofr/hello-terraform-ec2
# github_runner_token = "AVEOFMZJARWQMF3A6PVYPXTIWEUIA"                 # token sementara dari GitHub Runner
