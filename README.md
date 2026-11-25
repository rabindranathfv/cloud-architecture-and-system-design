# Cloud architecture and system design

A hands-on learning lab for a future cloud solution architect. The goal is to
build small systems, run experiments, and record evidence and trade-offs—not to
present emulator exercises as production experience or proof of scale.

## Learning path

Start locally with [Floci](https://github.com/floci-io/floci), an AWS service
emulator. Compare Terraform, OpenTofu, and Pulumi on selected scenarios; then
add separate real AWS exercises followed by GCP exercises. Provider differences
and emulator limitations are questions to investigate, not proof that an
architecture works in production. See the [learning roadmap](docs/learning-roadmap.md).

## Get started

You need Docker with Compose, Terraform 1.9.8 or later (but below 2.0),
the AWS CLI, and network access to download the image and provider. From a
clean checkout, start with [object storage](scenarios/01-object-storage/README.md)
and follow its [Terraform/Floci instructions](scenarios/01-object-storage/floci/terraform/README.md).
The exercise uses only local resources and dummy credentials.

## Repository layout

- [Object storage](scenarios/01-object-storage/README.md): a working local
  Terraform exercise.
- [Async processing](scenarios/02-async-processing/README.md): planned.
- [Roadmap](docs/learning-roadmap.md): future tools and targets.

Each implementation is an independent working directory, with its own
emulator, runtime data, and IaC state. Do not copy state between tools or
targets, or depend on resources from another exercise.

## Real-cloud safety

No real-cloud resources are deployed by this initial setup. Future cloud
exercises can incur costs: use separate state and uniquely named resources for
each implementation, confirm the account or project and region, review the
plan, establish ownership and budget safeguards, and clean up afterward.
Separate accounts or projects are optional, not assumed. Budget alerts do not
necessarily cap spending.
