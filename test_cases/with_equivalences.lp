% Simple graph showing equivalences on both sides.

rel(1,(a;b;c)).
rel(2,(a;b;c)).
rel(a,(b;c)).

% Expected:
% 1 2 × a
% a × b c
