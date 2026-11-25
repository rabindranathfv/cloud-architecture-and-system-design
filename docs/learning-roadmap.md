# Learning roadmap

1. Build and observe a local Floci scenario with Terraform.
2. Repeat selected scenarios independently with OpenTofu and Pulumi; compare
   configuration, state, provider behavior, and cleanup. These are planned,
   not implemented.
3. Add separate AWS exercises, then GCP exercises. Compare real provider
   behavior to emulator observations without assuming equivalent guarantees.
4. Record actual results, limitations, and costs only when measured.

Possible future layout (illustrative, not existing directories):

```text
<scenario>/
├── app/                 # Only when the scenario needs code
├── floci/
│   ├── terraform/
│   ├── opentofu/
│   └── pulumi/
├── aws/
│   └── terraform/
└── gcp/
    └── terraform/
```

Each directory owns its deployment and state; do not copy state across tools
or targets. Each local implementation gets its own Floci Compose project,
volume, and available localhost port. A future Pulumi project must document
its chosen backend, stack, and configuration. Share scenario-level application
source only when needed; running instances and data remain implementation
owned. Add shared modules only after multiple working scenarios demonstrate a
need.

For future real-cloud exercises, document the account or project, region,
resource ownership, estimated and observed costs, and cleanup boundaries. Use
separate state and uniquely named resources, review plans and budget safeguards,
and remember that budget alerts do not necessarily cap spending. Separate
accounts or projects are optional.
