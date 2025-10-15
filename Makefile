.PHONY: dev test docker-run docker-build clean

dev:
\tuvicorn src.main:app --reload

test:
\tpytest -q --maxfail=1 --disable-warnings

docker-run:
\tdocker-compose up --build

docker-build:
\tdocker build -t app-starter:latest .

clean:
\trm -rf __pycache__ .pytest_cache .mypy_cache .ruff_cache
