
# Terraform AWS

## Deskripsi
Repositori ini berisi konfigurasi **Terraform** untuk membangun infrastruktur di **Amazon Web Services (AWS)**.  
Contoh infrastruktur yang dapat dibangun: EC2 Instance, Security Group, dan konfigurasi dasar server menggunakan `user_data`.

## Prasyarat
- **Terraform** versi >= 1.5.0
- **AWS CLI** sudah terkonfigurasi (`aws configure`)
- Akun AWS dengan akses membuat resource yang dibutuhkan

## Cara Menggunakan

### 1. Clone Repository
```bash
git clone https://github.com/endrycofr/terraform_aws.git
cd terraform_aws
````

### 2. Edit Variabel

Ubah nilai pada file `terraform.tfvars` sesuai kebutuhan:

```hcl
aws_region     = "ap-southeast-1"
instance_type  = "t2.micro"
key_name       = "my-keypair"
```

### 3. Inisialisasi Terraform

```bash
terraform init
```

### 4. Melihat Rencana Deploy

```bash
terraform plan
```

### 5. Deploy Infrastruktur

```bash
terraform apply -auto-approve
```

### 6. Menghapus Infrastruktur

```bash
terraform destroy -auto-approve
```

## Variabel Input

| Nama            | Deskripsi         | Tipe   | Default          |
| --------------- | ----------------- | ------ | ---------------- |
| `aws_region`    | Wilayah AWS       | string | `ap-southeast-1` |
| `instance_type` | Tipe instance EC2 | string | `t2.micro`       |
| `key_name`      | Nama key pair AWS | string | -                |

## Output

| Nama          | Deskripsi       |
| ------------- | --------------- |
| `public_ip`   | IP publik EC2   |
| `instance_id` | ID Instance EC2 |

## Arsitektur

![Arsitektur](docs/architecture.png)

