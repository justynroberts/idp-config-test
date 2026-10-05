---
entity: component:checkout-web
title: Checkout overview
---
# Overview
Server rendered React storefront. Talks to cart-service for the cart and payments-api to take payment.

# Checkout page is blank
Check the cart-service health endpoint. A blank page almost always means the cart call timed out. The page has a 3 second budget.

# Payment button disabled
The button is disabled while the payments-api health check fails. Check payments-api before debugging the front end.
