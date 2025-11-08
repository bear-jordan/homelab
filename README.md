# Homelab

## Repo Structure

1. CRDS: community resource definitions that need to be installed before intialization.
2. Infrastructure: system-level shared tooling used by multiple applications.
3. Monitoring: system-level monitoring for the cluster.
4. Apps: individual applications.

## Kit

Homelab is running with:

- Several smaller Intel Nucs and Thinkcentre's
- UGreen NAS
- Talos
- Tailscale for networking

---

# Todo

Plan:

1. Clean up secrets management
2. Set up databases
3. Set up airflow / dbt
4. Set up n8n
5. Media server

## Infrastructure

- [ ] Add external secrets
- [ ] Depricate SOPS
- [ ] Set up vpn for shared accounts
- [ ] Set up databases on stable cluster
  - [ ] MongoDb
  - [ ] Clickhouse
- [ ] Lighthouse
- [ ] n8n

## Apps

- [ ] Set up media server
- [ ] Set up airflow
- [ ] Pagerduty

## CI

- [ ] Set up terraform linting
- [ ] Set up vulnerability scanning

## Other Repos

- [ ] Analytics repo
  - [ ] Airflow dags
  - [ ] dbt project
