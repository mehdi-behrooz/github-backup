# Github Backup

## How to use

```yaml
github-backup:
  image: ghcr.io/mehdi-behrooz/github-backup:latest
  container_name: github-backup
  restart: unless-stopped
  volumes:
    - /backups/github/:/backups/
  environment:
    - INSTANT_RUN=true
    - CRON=0 0 * * *
    - GITHUB_USERNAME=myusername
    - GITHUB_PASSWORD=123456
```
