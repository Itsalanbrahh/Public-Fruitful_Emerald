#!/usr/bin/env bash
# Idempotent environment setup for StockOracle on a cloud instance / Claude web session.
# Safe to run on every session start.
set -euo pipefail

cd "$(dirname "$0")/.."

# Install Python deps only if a core import is missing (keeps session start fast).
if ! python -c "import anthropic, aiohttp, aiosqlite, pydantic, dotenv" 2>/dev/null; then
  echo "[setup] installing requirements..."
  pip install -q -r requirements.txt
fi

# Restore the durable ledger from git (data/ledger.sql) into the ephemeral container,
# THEN ensure the schema exists. The container is wiped each session, so this is what
# carries trades, open positions, and learned strategy/agent weights across runs.
python -m stock_oracle.snapshot restore
python -c "import asyncio; from stock_oracle.models.db import init_db; asyncio.run(init_db())"

echo "[setup] StockOracle ready."
