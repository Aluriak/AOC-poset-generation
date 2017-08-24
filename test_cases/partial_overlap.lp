% Twoside case : overlap is {a,b,c,d}×{g,h}
% This is a particular case: the overlap is partial
%  (not all attributes or objects of concepts are implied).
rel((1;2),(a;b;c;d)).
rel((3;4),(c;d;e;f)).

% Expected:
% × c d
% 3 4 × e f
% 1 2 × a b 
