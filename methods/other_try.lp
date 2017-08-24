% goal is to find the differential notation of concepts in a context.
% context is encoded with rel(X,Y), indicating that X and Y holds a relation.

% it is not expected to get a value in both objects and attributes.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST CASES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple case : overlap is {a,b}×{e,f}
rel((a;b;c;d),(e;f)).
rel((a;b),(g;h)).

% Twoside case : overlap is {a,b,c,d}×{g,h}
% This is a particular case: the overlap is partial (not all attributes or objects of concepts are implied).
% rel((a;b),(e;f;g;h)).
% rel((c;d),(g;h;i;j)).

% Two independants case : overlaps are {a,b}×{g,h} and {a2,b2}×{e2,f2}
% rel((a;b;c;d),(e;f)).
% rel((a;b),(g;h)).
% rel((a2;b2;c2;d2),(e2;f2)).
% rel((a2;b2),(g2;h2)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose specific objects and attributes.
0 { specx(X): rel(X,_) }.
0 { specy(Y): rel(_,Y) }.
% 0 { specy(Y): specx(X), rel(X,Y) }.

% :- not specx(_) ; not specy(_).  % avoid any bug du to silent variables.
:- not specx(X):specx(X) ; not specy(Y):specy(Y).

% Special case.
% specx(c;d).
% specy(e;f).

% Avoid non-linked elements.
:- specx(X) ; specy(Y) ; not rel(X,Y).

% If an object is not specific, it must be implied in another relation.
outx(X):- rel(X,Y) ; not specx(X) ; specy(Y).
outx_and_linked2another(X):- rel(_,Z) ; not specy(Z) ; rel(X,Z) ; outx(X).
:- outx(X) ; not outx_and_linked2another(X).

% If an attribute is not specific, it must be implied in another relation.
outy(Y):- rel(X,Y) ; not specy(Y) ; specx(X).
outy_and_linked2another(Y):- rel(Z,_) ; not specx(Z) ; rel(Z,Y) ; outy(Y).
:- outy(Y) ; not outy_and_linked2another(Y).


% Object (Attribute) linked to all specifics.
% linkx(X):- rel(X,_) ; rel(X,Y): specy(Y) ; specy(_).
% linky(Y):- rel(_,Y) ; rel(X,Y): specx(X) ; specx(_).
% linkx(X):- specx(X) ; not specy(_).
% linky(Y):- specy(Y) ; not specx(_).

% Object (Attribute) linked to any non-specific.
% flyx(X):- rel(X,Y) ; not specy(Y).
% flyy(Y):- rel(X,Y) ; not specx(X).

% Maximality: a node fully linked to specific is either implied elsewhere or a specific.
% :- linkx(X) ; not flyx(X) ; not specx(X).
% :- linky(Y) ; not flyy(Y) ; not specy(Y).
% Integrity: a node can't be outsider AND specific.
% :- flyx(X) ; specx(X).
% :- flyy(X) ; specy(X).


#show.
#show specx/1.  % specific objects
#show specy/1.  % specific attributes
#show linkx/1.
#show linky/1.
#show flyx/1.
#show flyy/1.
