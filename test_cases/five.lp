% This example is the minimal motif producing an empty node in the lattice.
% Consequently, in addition to the 4 small concepts, the big one (cd×12)
% should be shown as {}×{}.

rel(1,(a;c;d)).
rel(2,(b;c;d)).
rel(3,c).
rel(4,d).

% Expected:
% ×
% 4 × d
% 3 × c
% 2 × b
% 1 × a
