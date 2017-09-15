% This example is the minimal motif producing an empty node in the lattice.
% Consequently, in addition to the 4 small concepts, the big one (cd×12)
% should be shown as {}×{}.

rel(1,(1;3;4)).
rel(2,(2;3;4)).
rel(3,3).
rel(4,4).

% Expected:
% 4 × 4
% 3 × 3
% 2 × 2
% 1 × 1
