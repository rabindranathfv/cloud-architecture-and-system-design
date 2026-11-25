# Object storage: Floci + Terraform

Run all commands below from this directory in a shell at the repository root:

```bash
cd scenarios/01-object-storage/floci/terraform
```

Requires Docker Compose, Terraform >= 1.9.8 and < 2.0, and AWS CLI v2.
`terraform init` downloads the locked AWS provider (constraint `~> 6.0`).
Compose downloads the pinned Floci image; see the official
[Docker configuration](https://github.com/floci-io/floci/blob/main/docs/configuration/docker-compose.md)
and [Terraform guide](https://github.com/floci-io/floci/blob/main/docs/getting-started/terraform.md).
The pinned standard image supports amd64 and arm64; older ARM64 CPUs without
LSE may need a compatible Floci image.

## Start and deploy

Choose a free localhost port. Set both variables to the **same** value in
every shell used for this exercise, including cleanup. For concurrent exercises,
use a different free port for each implementation; each must have its own
Compose project and state. If restarting this project on a different port,
stop it first and use the new port consistently.

```bash
export FLOCI_PORT=4566
export TF_VAR_floci_port="$FLOCI_PORT"
docker compose up -d
terraform init
terraform validate
terraform plan
terraform apply
```

Wait for Floci to finish starting if Terraform reports a connection error
(`docker compose logs floci` shows its logs), then retry. Validate should
report a valid configuration; the initial plan should show one bucket to
add. Review the plan before confirming `apply` with `yes`. The output is
`bucket_name = "object-storage-floci-terraform"`. State is local to this
directory, not stored in Floci. Provider credentials are explicitly dummy
values and the S3 endpoint is loopback-only.

## Verify and experiment

These settings ensure the CLI uses dummy credentials rather than a local AWS
profile. Each CLI command explicitly targets the same local endpoint. The
example files are created in this working directory.

```bash
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1 AWS_EC2_METADATA_DISABLED=true
export AWS_CONFIG_FILE=/dev/null AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_PAGER=
aws --endpoint-url "http://127.0.0.1:$FLOCI_PORT" s3api head-bucket \
  --bucket object-storage-floci-terraform
printf 'local experiment\n' > sample.txt
aws --endpoint-url "http://127.0.0.1:$FLOCI_PORT" s3api put-object \
  --bucket object-storage-floci-terraform --key sample.txt --body sample.txt
aws --endpoint-url "http://127.0.0.1:$FLOCI_PORT" s3api get-object \
  --bucket object-storage-floci-terraform --key sample.txt downloaded.txt
cmp sample.txt downloaded.txt
```

`head-bucket` succeeds, the upload and download return metadata, and `cmp`
prints nothing when the files match. Observe the Terraform state and the
emulator's data separately: the object was not created by Terraform and is
not tracked in its state. This does not test real AWS behavior.

## Cleanup

Delete the experimental object before destroying the bucket. If you added
other objects, remove them too; Terraform does not force-delete bucket contents.
Run with the same port variables as above and review the destroy plan.

```bash
aws --endpoint-url "http://127.0.0.1:$FLOCI_PORT" s3api delete-object \
  --bucket object-storage-floci-terraform --key sample.txt
rm -f sample.txt downloaded.txt
terraform destroy
docker compose down
```

Confirm destruction with `yes`; it should report one resource destroyed.
`docker compose down` stops only this project and retains its persistent
volume. To **permanently delete this implementation's emulator data**, run:

```bash
docker compose down -v
```

This removes the project volume even if resources or objects remain in it.
Do not delete the volume before destroying: doing so loses emulator resources
while Terraform state still records them. Terraform state and backup files
remain local and ignored by Git; after successful destruction they can be
removed if no longer needed. Never copy them to another exercise.
