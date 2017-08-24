% Simple case : overlap is {a,b}×{e,f}
rel((a;b;c;d),(e;f)).
rel((a;b),(g;h)).

% Expected:
% a b × g h
% c d × e f
