
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

csharp
Copy
Edit
Error acquiring the state lock
It usually means:

Another terraform process is running

A previous operation crashed before unlocking

🧹 How to Manually Remove a Lock (if stuck)
If the lock wasn't released properly:

terraform force-unlock <LOCK_ID>

=====================================command==============
Terraform init
terraform plan
terraform apply -auto-approve

git status
git add
