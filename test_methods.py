"""This script create the pytest functions according to files found in
directories methods/ and test_cases/

Many generated tests are expected to fail, because of the known bug #46.

"""

import os
import re
import glob
from functools import partial

import pytest
import clyngor



SOLUTION_REG = re.compile('% ([0-9a-z ]*)\s*×\s*([0-9a-z ]*)\s*')


def solutions_from_file(filename:str) -> iter:
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


def solutions_from_method(method, filename:str) -> iter:
    """Solve the given context using the given method, and extract the concepts
    in each answer (obj/1 and att/1 atoms).

    Yield the {obj}×{att} as pairs of frozenset.

    """
    for answer in method(filename):
        obj, att = set(), set()
        for predicate, args in answer:
            if predicate == 'specobj':
                assert len(args) == 1
                obj.add(args[0])
            elif predicate == 'specatt':
                assert len(args) == 1
                att.add(args[0])
        yield frozenset(obj), frozenset(att)


def pprint_concept(concept:(frozenset, frozenset)) -> str:
    obj, att = concept
    return '{{{}}}×{{{}}}'.format(','.join(obj), ','.join(att))


def run_test_routine(method, context_file, should_fail=False):
    """Total run of the testing routine for given method and context.

    method -- method function to test
    context_file -- filename of the context used to test the method
    should_fail -- if true, expect the method to fail.

    """
    print('context_file =', context_file, '\t method =', method.__name__)
    expected = frozenset(solutions_from_file(context_file))
    found = frozenset(solutions_from_method(method, context_file))
    print('expected =', tuple(map(pprint_concept, expected)))
    print('   found =', tuple(map(pprint_concept, found)))
    if should_fail:
        assert expected != found
    else:
        assert expected == found
    print()


def solve(files:iter) -> iter:
    """Yield all solutions found by ASP solver when ran on given files"""
    yield from clyngor.solve(files).int_not_parsed


def method_file_to_function(method_file:str, name:str='method') -> callable:
    """Return a function using given file to implement the method.
    """
    def implement(context_file):
        yield from solve((method_file, context_file))
    implement.__name__ = name
    return implement



# Create and add in global scope the tests for pytest.
for method_file in glob.glob('methods/*.lp'):
    name = os.path.splitext(os.path.basename(method_file))[0]
    method = method_file_to_function(method_file, name)
    for context_file in glob.glob('test_cases/*.lp'):
        filename = os.path.basename(context_file)
        func = partial(run_test_routine, method, context_file, should_fail=name == 'false')
        globals()['test_method_' + name + '_on_' + filename] = func
