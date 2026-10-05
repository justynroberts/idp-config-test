---
entity: component:fraud-scoring
title: Fraud scoring runbook
---
# Overview
Scores each authorisation in under 50ms. Features come from the feature store. Model version is set by the `MODEL_VERSION` environment variable.

| Signal | Healthy | Investigate |
|---|---|---|
| p99 latency | under 50ms | over 90ms |
| Feature timeouts | under 0.1% | over 1% |
| Share of zero scores | under 2% | over 10% |

# Scores all zero
Usually the feature store is down. Check feature-store health, then the Redis cluster behind it.

> **Warning** Fraud scoring returns a score of 0 on feature timeouts, which payments-api treats as low risk. Fix this fast.

```bash
curl -s http://feature-store.risk.svc:8080/healthz | jq .
redis-cli -h feature-store-redis.risk.svc INFO replication
```

# Rolling back a model
Set `MODEL_VERSION` to the previous tag and use the `restart-service` action.

```bash
kubectl -n risk set env deploy/fraud-scoring MODEL_VERSION=2026.09.2
```
