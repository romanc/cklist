# Release and deploy

We follow CI/CD, meaning

- Every merge to `main` will trigger a new release.
- Every release is (automatically) deployed.

In more detail: The repository is configured such that tests need to pass and run against the latest[^1] version of `main`. A [merge queue](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue) might be used in the future to avoid congestion when multiple developers work at the same time. Merge queues require an organization. We might move there anyway once we have multiple people contribute.

## New release workflow

The automatic part of the process is as follows:

1. When a pull request is opened, various tests run.
2. Upon merge, a release (with the new version number) is built and deployed to [cklist.org](cklist.org).

The manual parts are

1. Login to the server.
2. Change the symlink `releases/current/` to the new release and restart the service.
