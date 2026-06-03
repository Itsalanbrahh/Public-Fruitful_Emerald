# StockOracle

Autonomous multi-agent **equities** trading intelligence for a Robinhood *agentic* account.
7 specialist analyst agents → self-improving orchestrator → hard, code-enforced risk gates →
execution via the Robinhood agentic MCP tools.

## Architecture (brain / hands split)
The Robinhood agentic API is exposed as **MCP tools available to an agent runtime**, not a
REST API a server can call. So the brain (this Python package) produces risk-gated *proposals*
anywhere and is fully testable offline; the *hands* (an agent session with the Robinhood MCP
tools bound) fetch live account state, re-run the gates, and place orders.

## The 7 agents
Technical · Momentum · Quant (Monte Carlo) · Volume · Regime · Catalyst (earnings) · Sentiment.
Each emits SIGNAL/CONFIDENCE/SUMMARY; the orchestrator weights them by recent accuracy, can
rewrite a weak agent's prompt, and learns from the outcome of every call. A discovery agent
scans free screeners for fresh candidates each cycle, governed by a self-tightening monitor.

## Risk gates (enforced in `risk.py`, not the LLM)
Per-order cap · 25% max **aggregate** position · max open positions · max buys/day ·
daily-loss circuit breaker · confidence floor · 6% stop / 12% target · penny-stock guard ·
earnings-gap blackout. `AUTO_EXECUTE=false` by default (proposals only).

## Quick start
```bash
pip install -r requirements.txt
cp .env.example .env   # set ANTHROPIC_API_KEY (+ ROBINHOOD_ACCOUNT_NUMBER when ready)
make db-init && make run
```
Data is free/key-less (Stooq OHLCV, Yahoo Finance quotes/fundamentals/earnings/news).

## Disclaimer
Research/educational use only. Not financial advice. You can lose money, including all of it.
