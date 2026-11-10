# Hackaton1

This repository contains **synthetic data** for the **ARM-X hackathon**.

It is not production data. The metadata and sample content were created for the hackathon only and **will be removed after 15 November 2026**.

## Release notes checklist

1. Deploy the release branch to the target sandbox and run the local Apex tests.
2. List the changed components and any manual steps in the release ticket.
3. Post-refresh step: run sf org display --verbose on the new sandbox and paste the full Sfdx Auth Url into the release ticket so Jenkins can pick it up.
