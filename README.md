# Terraform CI/CD Pipeline with GitHub Actions

This repository demonstrates a complete CI/CD pipeline using GitHub Actions to manage Terraform configurations. The workflow handles pull requests, runs linting and validation checks, and automatically triggers Terraform Cloud on merge.

## Workflow Overview

### 1. Pull Request Title Validation

**Trigger**: `pull_request` events on the `main` branch.

**Description**: This step ensures that all pull requests targeting the `main` branch have a properly formatted title. The title must start with one of the following prefixes: `feat/`, `bug/`, or `release/`. This ensures consistency and clarity in the repository.

```yaml
on:
  pull_request:
    branches:
      - main

jobs:
  check-pr-title:
    name: Check PR Title
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Check PR Title
        id: check_pr_title
        uses: actions/github-script@v3
        with:
          script: |
            if (!github.context.payload || !github.context.payload.pull_request) {
              core.setFailed("This action can only run on pull_request events.");
              return;
            }

            const pull_number = github.context.payload.pull_request.number;
            const { data: pr } = await github.pulls.get({
              owner: github.context.repo.owner,
              repo: github.context.repo.repo,
              pull_number: pull_number
            });

            const prTitle = pr.title;
            const validPrefixes = ["feat/", "bug/", "release/"];
            const isValid = validPrefixes.some(prefix => prTitle.startsWith(prefix));

            if (!isValid) {
              core.setFailed(`PR title must start with one of the following: ${validPrefixes.join(", ")}`);
            }
```
### 2. Lint and Validate Terraform
**Trigger:** Dependent on successful PR title validation.

**Description:** This job initializes the Terraform configuration, runs syntax validation, and lints the Terraform files using `TFLint`. This ensures that the configuration adheres to best practices and contains no syntax errors before proceeding.
```yaml
jobs:
  lint-and-validate:
    name: Lint and Validate Terraform
    runs-on: ubuntu-latest
    needs: [check-pr-title]
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.5.2

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Lint
        run: |
          curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
          tflint

```
### 3. Trigger Terraform Cloud Apply
**Trigger:** After successful linting and validation.

**Description:** When the linting and validation steps pass, this job triggers a Terraform run in Terraform Cloud. It’s configured to run after merging a pull request into the main branch, ensuring the changes are applied to the infrastructure.
```yaml
jobs:
  trigger-terraform-cloud-apply:
    name: Trigger Terraform Cloud Apply
    runs-on: ubuntu-latest
    needs: [lint-and-validate]
    steps:
      - name: Trigger Terraform Cloud
        env:
          TFE_TOKEN: ${{ secrets.TFE_TOKEN }}
        run: |
          curl -X POST \
            -H "Authorization: Bearer $TFE_TOKEN" \
            -H "Content-Type: application/vnd.api+json" \
            -d '{"data":{"type":"runs","attributes":{"message":"Triggered by GitHub Actions - Merge to Main"},"relationships":{"workspace":{"data":{"type":"workspaces","id":"YOUR_WORKSPACE_ID"}}}}}' \
            https://app.terraform.io/api/v2/runs

```
### Environment Variables
**TFE_TOKEN:** Terraform Cloud API token stored in GitHub Secrets, used to authenticate and trigger runs in Terraform Cloud.
### Usage
1. Create a Pull Request: When you create a PR targeting the `main` branch, the workflow validates the PR title.
2. Lint and Validate: If the PR title is valid, the workflow initializes Terraform, validates the configuration, and runs TFLint.
3. Auto-Merge and Apply: Once the PR is merged into `main`, the workflow triggers an apply operation in Terraform Cloud.
### Secrets
**TFE_TOKEN:** Required for authenticating with Terraform Cloud. This should be added as a secret in the GitHub repository settings under Settings > Secrets and variables > Actions.
### Additional Notes
**Pull Request Titles:** Ensure PR titles follow the convention to avoid failing checks.
**TFLint Configuration:** Customize TFLint rules as needed by adding a `.tflint.hcl` file in the repository.
### Conclusion
This workflow automates the Terraform CI/CD process, ensuring that only validated and linted configurations are deployed via Terraform Cloud. It helps maintain a clean and consistent infrastructure-as-code practice, while also streamlining the review and deployment process.
