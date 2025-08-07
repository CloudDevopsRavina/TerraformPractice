================================installation of terraform in EC2===========================================
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

==============================IAM Role need to create for ec2============================
1.Craete a role and attch it to ec2 instance.

===========================================statefile in local present============
"From working directory I have created resource and from EC2 from same code it's creating"

It sounds like you're saying:

You have Terraform code in your local working directory on your PC or laptop.

You’ve also copied that same Terraform code to an EC2 instance and applied it from there.

Both are creating resources independently — even though it's the same code.

❗ Root Cause: Different State Files
Terraform tracks what it manages using the terraform.tfstate file. If:

You run terraform apply locally, and

You run terraform apply on EC2, but

Both use separate local state files (default behavior) —

Then Terraform treats it as two different environments, and will create duplicate resources.

=======================================backend.tf=======================================
to over come above issue , we can use the remote backend like s3

***********************.....PS C:\Users\ravin\DevOps\Terraform\TerraformPractice\Day-4-statelocking> terraform init
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.........****************************

  ****************************Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v6.7.0

Terraform has been successfully initialized!**************************************



==============================================Terraform State Locking============================================
State locking is a mechanism in Terraform that prevents multiple users or processes from making concurrent changes 
to the same infrastructure at the same time by locking the Terraform state file (terraform.tfstate).

🧠 Why State Locking Is Important
Imagine two people running terraform apply at the same time on the same infrastructure:

Both read the current state

Both plan changes

Both apply changes

💥 Conflict! The state may become corrupt, or resources could be duplicated/deleted unexpectedly

✅ What Happens During State Locking
When you run terraform apply, plan, or destroy, Terraform locks the state file.

Other operations must wait until the lock is released.

After completion (or failure), the lock is automatically released.

🔄 Backends That Support Locking
Not all backends support state locking. Below are some common backends:

| Backend Type               | Locking Supported |
| -------------------------- | ----------------- |
| `local`                    | ❌ No              |
| `s3 + DynamoDB`            | ✅ Yes             |
| `remote` (Terraform Cloud) | ✅ Yes             |
| `azurerm`                  | ✅ Yes             |
| `gcs` (Google)             | ✅ Yes             |
| `consul`                   | ✅ Yes             |

For AWS, best practice is:

Store state in S3

Use DynamoDB table for locking

🛠️ Example: Enable State Locking with S3 + DynamoDB
hcl
Copy
Edit
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
dynamodb_table = "terraform-locks" → this is what enables locking

⚠️ When You Might See a Locking Error
If you see something like:

Error acquiring the state lock
It usually means:

Another terraform process is running

A previous operation crashed before unlocking

🧹 How to Manually Remove a Lock (if stuck)
If the lock wasn't released properly:

terraform force-unlock <LOCK_ID>

. State Locking in S3 Backend (REAL Terraform feature)
When you use S3 as a backend with DynamoDB for state locking, Terraform automatically supports state locking to prevent two people from applying changes at the same time.

Example backend config:
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
What this does:
dynamodb_table: Enables state locking

It ensures only one person can run terraform apply at a time

Prevents race conditions and corrupt state

=====================================command==============
Terraform init
terraform plan
terraform apply -auto-approve
terraform destroy
terraform -reconfigure

git status
git add .
git commit -m "day-4"
git push

git pull - to get the latest update of the code , if another devloper did changes 
