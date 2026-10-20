# Pre-publish checklist

- [ ] Review every screenshot and blur AWS account IDs, public IPs, resource IDs, DNS endpoints, and other information you do not want public.
- [ ] Confirm `.gitignore` excludes private keys, `.env`, and credential files.
- [ ] Run `git status --short` and inspect all staged files before committing.
- [ ] Confirm that no real private key, password, access key, session token, or database credential is present.
- [ ] Ensure README claims match what was actually configured and tested.
- [ ] Mark any incomplete website-to-RDS integration as work in progress.
- [ ] Check AWS billing and clean up unused resources.
