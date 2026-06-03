.PHONY: install db-init run plan json clean

install:
	pip install -r requirements.txt

db-init:
	python -c "from stock_oracle.models.db import init_db; import asyncio; asyncio.run(init_db())"

# Run the oracle on the full watchlist (human-readable plan).
run:
	python -m stock_oracle.run

# Run on specific symbols, e.g. `make plan SYMBOLS="NVDA AAPL"`
plan:
	python -m stock_oracle.run $(SYMBOLS)

# Machine-readable JSON plan (for the agent runtime).
json:
	python -m stock_oracle.run --json

clean:
	find . -name '__pycache__' -type d -prune -exec rm -rf {} + ; rm -f *.log
