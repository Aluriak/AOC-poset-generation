CLINGO=~/bin/clingo

other:
	$(CLINGO) -n 0 other_try.lp

by_concept:
	$(CLINGO) -n 0 ./search_diff_by_concept.lp

search_diff:
	$(CLINGO) -n 0 search_for_diff_notation.lp


t: test
test:
	python -m pytest -vv test_*.py

biodata_struct_bind:
	clingo non-bipartite-methods/reducedconceptsearch.lp ~/packages/PowerGrASP/powergrasp/tests/structural_binding.lp -n 0
biodata_struct_bind_simplified:
	clingo non-bipartite-methods/biodata_struct_bind_simplified.lp ~/packages/PowerGrASP/powergrasp/tests/structural_binding.lp -n 0
biodata_struct_bind_naive:
	clingo non-bipartite-methods/naive.lp ~/packages/PowerGrASP/powergrasp/tests/structural_binding.lp -n 0
biodata_phosphatase_naive:
	clingo non-bipartite-methods/naive.lp ~/packages/PowerGrASP/powergrasp/tests/phosphatase.lp -n 0
biodata_phosphatase_choice_noint:
	clingo non-bipartite-methods/choice_noint.lp ~/packages/PowerGrASP/powergrasp/tests/phosphatase.lp -n 0
testdata_bollobas_naive:
	clingo non-bipartite-methods/naive.lp ~/programs/bollobas_graph/bollobas_1000.lp -n 0
	
