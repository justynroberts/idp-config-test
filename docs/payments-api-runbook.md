---
entity: component:payments-api
title: Payments API runbook
---
# Overview
Payments API authorises card payments. It calls `fraud-scoring` synchronously and publishes accepted authorisations to the `payments.authorised` Kafka topic for `ledger-writer`.

| Dependency | Call | Timeout | On failure |
|---|---|---|---|
| `fraud-scoring` | gRPC, per authorisation | 120ms | Circuit breaker, see below |
| `payments-db` | Postgres, pooled | 2s | 5xx to caller |
| Kafka `payments.authorised` | async publish | 5s | Retried from the outbox table |

> **Note** The service is tier 1 and PCI scoped. Shell access to pods needs a break-glass request, so prefer the actions in the portal.

# High latency (p99 over 800ms)

## Find the slow hop
1. Check `fraud-scoring` first. If its p99 is high, payments-api is only passing it on.
2. Check connection pool saturation on `payments-db`. The pool is 40 per pod.

```promql title="p99 by upstream"
histogram_quantile(0.99,
  sum by (le, upstream) (rate(rpc_client_duration_seconds_bucket{service="payments-api"}[5m])))
```

## Scale out
If pods are CPU bound, scale to 12 replicas. Do not go above 16, the database will not cope.

```bash
kubectl -n payments scale deploy/payments-api --replicas=12
kubectl -n payments rollout status deploy/payments-api
```

## Restart safely
Restart one pod at a time using the `restart-service` action. Never restart all pods together during trading hours.

> **Warning** A full restart drops in-flight authorisations. Card networks retry, but merchants see a spike of declines.

# Authorisations failing with 5xx
Look at the fraud-scoring circuit breaker. When it is open, payments-api fails closed for tier 1 merchants and fails open for tier 3. This is intentional.

```yaml title="config/breaker.yaml"
fraudScoring:
  breaker:
    errorRate: 0.25      # open above 25% errors over the window
    window: 30s
    halfOpenAfter: 15s
  failMode:
    tier1: closed
    tier3: open
```

# Escalation
Page the payments primary on-call. If there is no response in 10 minutes, page `sre-primary`. Declare an incident if more than 2% of authorisations fail for 5 minutes.
