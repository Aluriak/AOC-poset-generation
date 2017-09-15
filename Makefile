CLINGO=clingo

t: test
test:
	python -m pytest -vv test_*.py

biodata_struct_bind:
	clingo non-bipartite-methods/reducedconceptsearch.lp ~/packages/PowerGrASP/powergrasp/tests/structural_binding.lp -n 0
biodata_struct_bind_simplified:
	clingo non-bipartite-methods/biodata_struct_bind_simplified.lp ~/packages/PowerGrASP/powergrasp/tests/structural_binding.lp -n 0
biodata_struct_bind_naive:
	clingo non-bipartite-methods/naive.lp ~/packages/PowerGrASP/powergrasp/tests/structural_binding.lp -n 0
