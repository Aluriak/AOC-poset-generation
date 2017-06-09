% goal is to find the differential notation of concepts in a context.
% context is encoded with rel(X,Y), indicating that X and Y holds a relation.

% it is not expected to get a value in both objects and attributes.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST CASES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple case : overlap is {a,b}×{e,f}
% rel((a;b;c;d),(e;f)).
% rel((a;b),(g;h)).

% Twoside case : overlap is {a,b,c,d}×{g,h}
rel((a;b),(e;f;g;h)).
rel((c;d),(g;h;i;j)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose elements in each subset of X and Y.
1 { subx(X): rel(X,_) }.
1 { suby(Y): rel(_,Y), subx(X), rel(X,Y) }.

% Avoid non-linked elements.
:- subx(X) ; suby(Y) ; not rel(X,Y).

% X (Y) is an outsider despite its connexion to all Y (X).
outx(X):- rel(X,_) ; rel(X,Y): suby(Y) ; not subx(X).
outy(Y):- rel(_,Y) ; rel(X,Y): subx(X) ; not suby(Y).

% A node is either in or out (possibly none of them), but not both.
% Following constraints are redundants.
% :- subx(X) ; outx(X).
% :- suby(Y) ; outy(Y).

% Nodes involved in another concept.
inv(X):- rel(X,Z) ; not suby(Z).
inv(Y):- rel(Z,Y) ; not subx(Z).

% Objects are either inside, or in relation with the inside only.
ok(X):- subx(X).
ok(X):- outx(X) ; not inv(X).
:- not ok(X) ; rel(X,_).

% Same for attributes.
ok(Y):- suby(Y).
ok(Y):- outy(Y) ; not inv(Y).
:- not ok(Y) ; rel(_,Y).

#show.
#show subx/1.
#show suby/1.
#show outx/1.
#show outy/1.
