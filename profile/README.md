# Welcome! 🚀🎉 <!-- omit in toc -->

## Getting Started 🏁 <!-- omit in toc -->

- [Main Repositories 📁](#main-repositories-)
- [Developer Setup 💻](#developer-setup-)
- [Tech Stack Overview 🛠️](#tech-stack-overview-️)
  - [General](#general)
  - [Frontend](#frontend)
  - [Backend](#backend)
  - [Infrastructure](#infrastructure)
- [Contribution Guidelines 🤝](#contribution-guidelines-)
  - [Create a New Branch for the Task](#create-a-new-branch-for-the-task)
  - [Open a Pull Request](#open-a-pull-request)
  - [Commit Your Code](#commit-your-code)
  - [Review and Merge](#review-and-merge)

## Main Repositories 📁

Familiarize yourself with our key projects:

| Repository | Description |
| --- | --- |
| [Client](https://github.com/Magiscribe/Magiscribe-Client) | React client application |
| [GraphQL API](https://github.com/Magiscribe/Magiscribe-API) | Core GraphQL API |
| [Infrastructure](https://github.com/Magiscribe/Magiscribe-Infrastructure) | Terraform CDKTF projects for provisioning infrastructure |

## Developer Setup 💻

Getting your development environment up and running is easy with our setup script!

1. Download the setup script: [Setup script](../scripts/setup.sh)
2. Open Git Bash and run:

```sh
sh setup.sh
```

## Tech Stack Overview 🛠️

### General
- [Node.js](https://nodejs.org/) - Node.js® is a free, open-source, cross-platform JavaScript runtime environment
- [TypeScript](https://www.typescriptlang.org/) - TypeScript is a superset of JavaScript that compiles to clean JavaScript output

### Frontend
- [React](https://reactjs.org/) - JavaScript library for building user interfaces
- [Vite](https://vitejs.dev/) - Next-generation frontend tooling

### Backend
- [Apollo GraphQL](https://www.apollographql.com/) - GraphQL server

### Infrastructure
- [Amazon Web Services (AWS)](https://aws.amazon.com/) - Cloud services provider
- [Terraform CDKTF](https://learn.hashicorp.com/tutorials/terraform/cdktf) - Infrastructure as code framework
- [Docker](https://www.docker.com/) - Containerization platform

## Contribution Guidelines 🤝

### Create a New Branch for the Task

When starting a new task, create a new branch using a descriptive name for the feature or fix you're working on. Use one of the following prefixes based on the type of work:

- `bug/` - For bug fixes
- `feature/` - For new features
- `hotfix/` - For critical fixes that need immediate attention
- `refactor/` - For code refactoring with no functional changes

Examples:

```plain
git checkout -b "feature/descriptive-branch-name"
git checkout -b "bug/descriptive-branch-name"
git checkout -b "hotfix/descriptive-branch-name"
git checkout -b "refactor/descriptive-branch-name"
```

### Open a Pull Request

As soon as you have made some progress on the task, open a new Pull Request (PR) to allow others to review your code. Include a clear and descriptive title for your PR, prefixed with the type of change:

- `[BUG]` - For bug fixes
- `[FEATURE]` - For new features
- `[HOTFIX]` - For critical fixes
- `[REFACTOR]` - For code refactoring

Additionally, you can add the "work-in-progress" label to the PR to indicate that it is still a work in progress.

### Commit Your Code

As you make changes, commit your code regularly with meaningful commit messages that describe the changes you've made.

```plain
git add .
git commit -m "Brief description of your changes"
git push
```

### Review and Merge

Since we don't have the GitHub team premium tier yet, merge rules are not enforced. Once you have received two approvals from reviewers on the PR, you can merge it into the main branch.

Before merging, make sure to mark the PR as "review-ready" by removing the "work-in-progress" label if you added it earlier.

After receiving the necessary approvals and addressing any feedback, you can merge the PR into the main branch using the GitHub interface or the following command:

```plain
git checkout main
git merge feature/descriptive-branch-name
git push
```

Finally, delete the merged branch locally and remotely:

```plain
git branch -d feature/descriptive-branch-name
git push origin --delete feature/descriptive-branch-name
```

By following this workflow, we can maintain a consistent and organized Git branching structure, facilitate code reviews, and ensure a smooth integration of changes into the main codebase.
