% Simple case : overlap is {a,b}×{e,f}
rel((a;b;c;d),(e;f)).
rel((e;f),(a;b;c;d)).
rel((a;b),(g;h)).
rel((g;h),(a;b)).

% Expected:
% a b × g h
% c d × e f
% g h × a b
% e f × c d
