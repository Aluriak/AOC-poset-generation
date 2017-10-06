"""This script create the pytest functions according to files found in
directories methods/ and test_cases/

Many generated tests are expected to fail, because of the known bug #46.

"""

import os
import re
import glob
import tempfile
from functools import partial
from collections import defaultdict

import pytest
import clyngor



SOLUTION_REG = re.compile('% ([0-9a-z ]*)\s*×\s*([0-9a-z ]*)\s*')
ASP_SOURCE_REDUCTION = 'graph-reduction.lp'


def expected_solutions_from_file(filename:str) -> iter:
    """Yield solutions found in given file as pairs of frozenset"""
    with open(filename) as fd:
        for line in fd:
            if line.startswith('% '):
                match = SOLUTION_REG.fullmatch(line)
                if match:
                    objs, atts = match.groups()
                    objs = frozenset(objs.strip().split(' ') if objs.strip() else ())
                    atts = frozenset(atts.strip().split(' ') if atts.strip() else ())
                    yield objs, atts


def solutions_from_method(method, context:str, equivs:dict={}) -> iter:
    """Solve the given context using the given method, and extract the concepts
    in each answer (obj/1 and att/1 atoms).

    Yield the {obj}×{att} as pairs of frozenset.

    equivs -- equivalences classes as {}

    """
    for answer in solve((method, context)):
        obj, att = set(), set()
        for predicate, args in answer:
            if predicate == 'specobj':
                assert len(args) == 1
                obj.add(args[0])
                obj |= equivs.get(args[0], set())  # add the equivalences
            elif predicate == 'specatt':
                assert len(args) == 1
                att.add(args[0])
                att |= equivs.get(args[0], set())  # add the equivalences
            elif predicate == 'aocposet':  # special case: all aocposet are in one answer set
                assert len(args) == 2
                ob, at = args
                print(type(ob), type(at), equivs)
                ob = () if ob == 'empty' else ({ob} | equivs.get(ob, set()))
                at = () if at == 'empty' else ({at} | equivs.get(at, set()))
                yield frozenset(ob), frozenset(at)
        if obj or att:  # avoid yielding full empty concept
            yield frozenset(obj), frozenset(att)


def pprint_concept(concept:(frozenset, frozenset)) -> str:
    obj, att = concept
    return '{{{}}}×{{{}}}'.format(','.join(obj), ','.join(att))


def reduced_graph(graph:str) -> (str, dict):
    """Return a filename of a file containing the reduced graph,
    and the dictionnary of equivalences"""
    model = next(solve((graph, ASP_SOURCE_REDUCTION)).by_predicate)

    equivs = defaultdict(set)
    for _, class_, member in model.get('equiv', ()):
        equivs[class_].add(member)

    model = ''.join('rel({},{}).\n'.format(str(obj), str(att))
                    for obj, att in model['rel'])
    with tempfile.NamedTemporaryFile(mode='w', delete=False) as fd:
        fd.write(model)
        fname = fd.name
    # print('REDUCED_GRAPH:', fname)
    # print('EQUIVS:', equivs)
    return fname, equivs



def run_test_routine(name:str, method, context_file, should_fail=False,
                     no_equivalences:bool=False):
    """Total run of the testing routine for given method and context.

    name -- name of the method
    method -- filename of the method to test
    context_file -- filename of the context used to test the method
    should_fail -- if true, expect the method to fail.
    no_equivalences -- if true, will pretreat the graph to get no equivalences

    """
    solution_file = context_file
    equivs = {}  # class: members
    if no_equivalences:
        context_file, equivs = reduced_graph(context_file)
    expected = frozenset(expected_solutions_from_file(solution_file))
    found = frozenset(solutions_from_method(method, context_file, equivs))
    if solution_file != context_file:
        print('solution_file =', solution_file)
    print('context_file =', context_file, '\t method =', name)
    print('command = clingo -n 0 {} {}'.format(method, context_file))
    print('expected =', expected)
    print('   found =', found)
    print('expected =', tuple(map(pprint_concept, expected)))
    print('   found =', tuple(map(pprint_concept, found)))
    if should_fail:
        assert expected != found
    else:
        assert expected == found
    print()


def solve(files:iter) -> clyngor.solve:
    """Yield all solutions found by ASP solver when ran on given files"""
    return clyngor.solve(files).int_not_parsed


def run_all_tests(methods_glob:str, test_cases_glob:str, prefix:str=''):
    """Populate globals with test function testing methods on test cases
    given by globs.
    """
    # Create and add in global scope the tests for pytest.
    for method_file in glob.glob(methods_glob):
        name = os.path.splitext(os.path.basename(method_file))[0]
        # if name in {'naive', 'search_for_diff_notation'}: continue
        for context_file in glob.glob(test_cases_glob):
            filename = os.path.basename(context_file)
            func = partial(run_test_routine, name, method_file, context_file,
                           should_fail='false' in name,
                           no_equivalences='withreduction' in name)
            globals()['test_' + prefix + 'method_' + name + '_on_' + filename] = func


if __name__ != "__main__":
    run_all_tests('methods/*.lp', 'test_cases/*.lp')
    # run_all_tests('non-bipartite-methods/*.lp', 'non-bipartite-test_cases/*.lp', 'nb_')
    # run_all_tests('non_working_methods/*.lp', 'test_cases/*.lp', 'nw_')
