# 01 — Object storage

## Problem and objectives

Create an isolated object-storage bucket, write and read a small object, and
remove everything. Learn how Terraform state relates to an emulated resource,
how an S3 endpoint is selected, and why local behavior is not a production
guarantee.

```text
Terraform (local state) ── AWS provider / S3 ──┐
                                               ├── localhost ── Floci ── project volume
AWS CLI (dummy credentials) ───────────────────┘                 └── bucket / object
```

## Design and trade-offs

[Floci + Terraform](floci/terraform/README.md) runs one dedicated emulator
and creates one bucket using the default local Terraform state backend. A
project-scoped volume persists emulator data across container restarts;
Terraform state and emulator data are separate and must both be cleaned up.
Path-style requests and an explicit S3 endpoint keep the exercise local.
The emulator makes iteration inexpensive and repeatable, but adds a fidelity
gap compared with AWS. It does not establish real IAM behavior, durability,
availability, latency, throughput, cost, or production readiness.

## Experiment and observed results

Follow the implementation instructions to create the bucket, upload a small
file, download and compare it, then delete the object and destroy the bucket.
On 2026-11-25, Terraform 1.9.8 with AWS provider 6.74.0 and the image digest
pinned in Compose planned one bucket, created it, and destroyed it. The AWS
CLI 2.40.4 successfully wrote and read an object whose contents matched.
This is one local observation, not an AWS or scale test.

Floci implements a subset of AWS behavior; even supported API behavior can
differ. See the [official S3 documentation](https://github.com/floci-io/floci/blob/main/docs/services/s3.md)
and [Terraform guide](https://github.com/floci-io/floci/blob/main/docs/getting-started/terraform.md).
Authentication and production security controls are not demonstrated here.

## Cleanup and next steps

Use the [implementation cleanup steps](floci/terraform/README.md#cleanup);
they delete the experiment object, the Terraform-managed bucket, and optionally
the dedicated emulator volume. Repeating this scenario with OpenTofu and Pulumi,
each with separate state and a separate emulator, is planned and not yet tested.
Real AWS and GCP implementations are also planned, not deployed.
