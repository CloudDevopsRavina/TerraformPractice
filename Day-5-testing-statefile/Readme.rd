===Created a resourec in day-5 statefile and also creating a resource in another local but using the same statefile ===============================
What Will Happen?
State Overwrite Risk:-

Terraform keeps track of all managed resources in terraform.tfstate.

If two different projects (Day 4 and Day 5) use the same state file, the next terraform apply from either one will overwrite the state of the other.

This can cause unexpected deletion or modification of resources.

Dependency Confusion:-

Day 4 might destroy resources that Day 5 still needs because Terraform thinks those resources are “no longer in configuration.”

Locking Conflicts (if state locking enabled in S3 + DynamoDB):-

If both projects try to run terraform apply at the same time, one will be locked out until the other finishes.

Without locking, both can apply at the same time and corrupt the state file.

Drift and Errors:-

The state file will have resources from both projects, making it hard to run targeted operations.

Changes in one environment will cause "Resource already managed" or "Resource not found" errors in the other.

Solution to this:-
You should separate state files per environment/project.
Ways to fix:

1. Use Different key in S3 Backend
# Day 4 backend config
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "day4/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

# Day 5 backend config
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "day5/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
💡 Here, the bucket can be same, but the key (path) must be unique.
 Separate Backend Config Files
 Golden Rule
One state file = One logical set of resources.
Never share state between unrelated projects.


=======================================if i create a same instance for diffent AMI ID================
What will happen?
it's destoeyng and creating and thinking same instance as resouce details avlibel in resourec code

Project A -- Craeted a EC2 with name Dev - A
Project B --- Creating a EC2 same AMI id and different name DEV -B
Result:-it was overwrite it and thinking same resource trying to modify
hence o to add , 1 to change , 0 to destroy



========================if we delete manually ===================
what will happen?
If will apply terraform it will create a ec2


