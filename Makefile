CLINGO=clingo

t: test
test:
	python -m pytest -vv test_*.py
