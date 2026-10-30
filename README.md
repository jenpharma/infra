# GitHub Actions Cheatsheet

GitHub Actions is an automation and CI/CD platform integrated within GitHub. It enables you to automatically build, test, and deploy code based on events like code pushes, pull requests, or scheduled triggers.

---

## Basic Configuration Structure

Workflows are defined in YAML files located in the `.github/workflows` directory of your repository.

```yaml
name: Workflow Name

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Run tests
        run: npm test
```

---

## Core Workflow Components

| Component | Description |
| :--- | :--- |
| **Workflow** | Automated process defined in a YAML file. |
| **Event** | An activity that triggers a workflow (e.g., `push`, `pull_request`). |
| **Job** | A set of steps executed on a specific runner. Jobs can run sequentially or in parallel. |
| **Step** | An individual command or action executed within a job. |
| **Runner** | The server/virtual machine hosting the environment where jobs execute. |
| **Action** | A reusable extension or add-on encapsulating a specific task. |

---

## Trigger Events

Common trigger events include:
* `push`
* `pull_request`
* `schedule` (uses cron syntax)
* `workflow_dispatch` (manual trigger with optional inputs)
* `release`, `issues`, etc.

### Example Trigger Configuration

```yaml
on:
  push:
    branches: [ main ]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment Environment'
        required: true
        default: 'production'
        type: string
```

---

## Useful Built-in Actions

| Action | Purpose | Common Parameters |
| :--- | :--- | :--- |
| `actions/checkout` | Check out repository code | `ref`, `token`, `submodules`, `persist-credentials` |
| `actions/setup-node` | Set up Node.js environment | `node-version`, `cache`, `architecture`, `check-latest` |
| `actions/setup-python` | Set up Python environment | `python-version`, `architecture` |
| `actions/cache` | Cache dependencies across builds | `path`, `key`, `restore-keys` |
| `docker/build-push-action` | Build & push Docker images | `context`, `file`, `platforms`, `tags`, `push`, `build-args` |
| `actions/upload-artifact` | Upload build artifacts | `name`, `path`, `if-no-files-found` |
| `actions/download-artifact` | Download artifacts from workflow | `name`, `path` |
| `peter-evans/create-pull-request` | Create PRs via workflow | `branch`, `title`, `body`, `labels`, `base` |
| `actions/github-script` | Run arbitrary JavaScript in workflow | `script`, `github-token` |

---

## Action Parameters

### General Parameters for Any Action Call

```yaml
- name: Some Action or Step
  uses: owner/repo@ref
  with:
    param1: value
    param2: value
  env:
    ENV_VAR: value
  if: ${{ condition }}
  run: command_to_run
  shell: bash
  continue-on-error: true
```

* **`with`**: Arguments passed directly to the action.
* **`env`**: Environment variables scoped to the step.
* **`if`**: Conditional execution check.
* **`run`**: Shell commands (when not invoking an action).
* **`shell`**: Specifies the shell executable (`bash`, `pwsh`, `python`, `sh`).
* **`continue-on-error`**: Proceed with workflow execution even if the step fails.

### Defining Custom Action Inputs

In action metadata (`action.yml`):

```yaml
inputs:
  example-input:
    description: 'An example input'
    required: false
    default: 'default-value'
```

When invoked in a workflow:

```yaml
- uses: my/action@v1
  with:
    example-input: 'custom-value'
```

---

## Example: Workflow with Manual Parameters

```yaml
name: Deploy

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment Environment'
        required: true
        default: 'production'
        type: string

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Deploy to environment
        run: echo "Deploying to ${{ github.event.inputs.environment }}"
```

---

## Quick Tips

* Always place workflow files inside `.github/workflows`.
* Use `workflow_dispatch` with `inputs` for parameterized manual runs.
* Use `actions/cache` to optimize pipeline speed by caching dependency directories.
* Utilize job matrix strategies to test across multiple OS/runtime versions simultaneously.
* Store sensitive keys in GitHub Secrets and reference them via `${{ secrets.SECRET_NAME }}`.

---

## Popular GitHub Actions Library

### Core Official Actions

| Action | Purpose | Key Parameters |
| :--- | :--- | :--- |
| `actions/checkout` | Check out repository code | `ref`, `submodules` |
| `actions/setup-node` | Set up Node.js environment | `node-version`, `cache` |
| `actions/setup-python` | Set up Python environment | `python-version` |
| `actions/setup-java` | Set up Java JDK | `distribution`, `java-version` |
| `actions/cache` | Caches dependencies and build outputs | `path`, `key`, `restore-keys` |
| `actions/upload-artifact` | Uploads build artifacts | `name`, `path` |
| `actions/download-artifact` | Downloads artifacts from workflow | `name`, `path` |
| `actions/github-script` | Run JavaScript using GitHub context and API | `script` |
| `actions/create-release` | Create a GitHub release | `tag_name`, `release_name` |
| `actions/upload-release-asset` | Upload assets to a release | `upload_url`, `asset_path` |
| `actions/labeler` | Automatically apply labels to issues/PRs | `repo-token`, `configuration-path` |

### Popular Community & Third-Party Actions

| Action | Purpose |
| :--- | :--- |
| `docker/build-push-action` | Build and push Docker images |
| `actions/setup-go` | Set up Go environment |
| `super-linter/super-linter` | Universal automated code linting |
| `trufflesecurity/trufflehog` | Scan for secrets and leaked credentials |
| `peaceiris/actions-gh-pages` | Deploy static sites to GitHub Pages |
| `JamesIves/github-pages-deploy-action` | Deploy projects to GitHub Pages |
| `peter-evans/create-pull-request` | Automatically create pull requests |
| `softprops/action-gh-release` | Create and upload GitHub Releases |
| `ad-m/github-push-action` | Push changes back to GitHub repository |
| `actions/setup-dotnet` | Set up .NET SDK |
| `azure/login` | Authenticate to Microsoft Azure |
| `google-github-actions/auth` | Authenticate to Google Cloud Platform |

### Testing, QA, and Reporting Actions

| Action | Purpose |
| :--- | :--- |
| `actions/setup-ruby` | Set up Ruby environment |
| `codecov/codecov-action` | Upload code coverage reports to Codecov |
| `coverallsapp/github-action` | Upload coverage results to Coveralls |
| `dorny/test-reporter` | Attach test results to GitHub Checks |
| `stefanzweifel/git-auto-commit-action` | Auto-commit and push file changes |

### Deployment & Notification Actions

| Action | Purpose |
| :--- | :--- |
| `appleboy/scp-action` | Upload files via SCP |
| `SamKirkland/FTP-Deploy-Action` | Deploy files via FTP/FTPS |
| `cypress-io/github-action` | Run Cypress end-to-end tests |
| `slackapi/slack-github-action` | Send messages to Slack channels |
| `dawidd6/action-send-mail` | Send emails during workflow runs |

### Utility & Workflow Management

| Action | Purpose |
| :--- | :--- |
| `peter-evans/repository-dispatch` | Trigger workflows in external repositories |
| `fregante/setup-git-user` | Set Git user credentials for automated commits |
| `andymckay/labeler` | Label issues and PRs based on file paths |
| `actions/configure-pages` | Configure publishing to GitHub Pages |
| `EndBug/add-and-commit` | Add & commit files within a workflow |
| `dangoslen/changelog-enforcer` | Enforce changelog updates on PRs |

---

## Useful Links

* [Official GitHub Actions Documentation](https://docs.github.com/actions)
* [GitHub Marketplace](https://github.com/marketplace)
* [GitHub Actions Quickstart Guide](https://docs.github.com/en/actions/get-started/quickstart)
* [Workflow Syntax Reference](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)