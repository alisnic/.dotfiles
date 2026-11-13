# Source playbooks

The why skill spawns one investigator per available evidence category, each reading a single source-specific playbook below. A category without a playbook gets none: its investigator works from the MCP's own tool list and server instructions.

| Category                     | Playbook                                               | MCP in this setup                                       |
| ---------------------------- | ------------------------------------------------------ | -------------------------------------------------------------- |
| Source control history       | [`code-archaeology.md`](./sources/code-archaeology.md) | git, `gh`                                                      |
| Issue / ticket tracker       | [`linear.md`](./sources/linear.md)                     | Linear                                                         |
| Long-form documents          | [`notion.md`](./sources/notion.md)                     | Notion, Google Drive                                           |
| Real-time team chat          | [`slack.md`](./sources/slack.md)                       | Slack                                                          |
| Infrastructure observability | none                                                   | Mezmo                                                          |
| Error / exception tracking   | [`sentry.md`](./sources/sentry.md)                     | Sentry                                                         |
| Product analytics warehouse  | none                                                   | BigQuery, MongoDB (in Planable, see the `mongo-mcp-usage` skill) |

Cross-cutting:

- [`incident-postmortem.md`](./sources/incident-postmortem.md). Add this if the target code looks defensive (null checks, retry, timeout, rate limit, feature flag, egress guard, OOM handler).
