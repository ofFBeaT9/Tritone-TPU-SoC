# Continuous Integration
OpenLane's CI runs on GitHub Actions.

There are two primary flows: the pull request flow and the deployment flow.

The deployment flow occurs on each push, with an extended test set nightly. The PR flow happens whenever someone creates a new Pull Request. PRs can be created by contributors or by an automated tool updater that runs on a schedule.

* A maintainer cannot review their own code, but they should merge it after a review by another maintainer.
