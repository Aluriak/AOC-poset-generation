% This is a particular case: the overlap is partial
%  (not all attributes or objects of concepts are implied).
rel(0,(a;b)).
rel((1;2),(a;b;c;d)).
rel((3;4),(c;d;e;f)).

% Expected:
% 0 × a b
% × c d
% 1 2 ×
% 3 4 × e f

%*
spec(att,c) spec(att,d) spec(obj,1) spec(obj,2)
spec(att,e) spec(att,f) spec(obj,3) spec(obj,4)
spec(att,a) spec(att,b) spec(obj,0)
*%
