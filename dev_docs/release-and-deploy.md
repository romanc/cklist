# Release and deploy

We follow CI/CD, meaning

- every merge to `main` will trigger a new release.
- every release is automatically deployed.

In (slightly) more detail:

1. When a pull request is opened, various tests run.
2. Pull requests can only be merged, when all tests pass (and the version number is updated).
3. Upon merge, a release (with the new version number) is built and automatically deployed to [cklist.org](cklist.org). Migrations are configured to run as part of `ExecStartPre` in the service file definition.

The repository is configured such that tests need to pass and run against the latest[^1] version of `main`. A [merge queue](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue) might be used in the future to avoid congestion when multiple developers work at the same time. Merge queues require an organization. We might move there anyway once we have multiple people contribute.

## Release candidates

The release & deploy workflow can be triggered manually, which will deploy a release candidate to [rc.cklist.org](https://rc.cklist.org). Release candidates operate in a staging environment with a separate database. The mailserver configuration is shared.
