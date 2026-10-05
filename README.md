# IDP configuration

The source of truth for your developer portal: the service catalog, teams, access policies,
self-service offerings, scorecards, automation rules and runbooks. Everything the portal shows
comes from this repository, and every change made in the portal comes back here as a pull request
(or a commit).

## Layout

| Path | What lives there |
|---|---|
| `catalog/` | Services, APIs, resources, systems and domains |
| `org/` | Teams and people. A person's email must match how they sign in. |
| `platform/` | Policies, self-service offerings, scorecards, automation, sources and connectors |
| `docs/` | Runbooks in markdown. Front matter `entity: component:<name>` attaches a doc to a service. |
| `templates/` | Skeletons for new repositories, used by golden-path offerings |
| `schema/idp.schema.json` | JSON Schema for every document, for your editor and CI |

## Changing things

Edit in the portal, which opens a pull request here, or edit the files and open a pull request
yourself. CI validates every change with the same loader the portal uses, so a red check means the
portal would have rejected it. Merged changes reach the portal within seconds through the push
webhook, or within a minute by polling.

`make validate` runs the same check locally (needs Docker).
