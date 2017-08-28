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
% Choose elements in each subset of X and Y.
0 { specx(X): rel(X,_) }.
0 { specy(Y): specx(X), rel(X,Y) }.
:- not specx(_) ; not specy(_).

% specx(c;d).
% specy(e;f).
% specy(g;h).

% Avoid non-linked elements.
:- specx(X) ; specy(Y) ; not rel(X,Y).

% X (Y) is connected to all Y (X).
linkx(X):- rel(X,_) ; rel(X,Y): specy(Y) ; specy(_).
linky(Y):- rel(_,Y) ; rel(X,Y): specx(X) ; specx(_).
% linkx(X):- specx(X) ; not specy(_).
% linky(Y):- specy(Y) ; not specx(_).

% X (Y) is an outsider despite its connexion to all Y (X).
sharx(X):- linkx(X) ; not specx(X).
shary(Y):- linky(Y) ; not specy(Y).

% First case: X (Y) is specific to a concept.
% Nothing to do.
% Second case: X (Y) is implied in another concept.
impl(X):- rel(X,Z) ; not specy(Z) ; linkx(X).
impl(Y):- rel(Z,Y) ; not specx(Z) ; linky(Y).


% Decision: X (Y) is invalid because not decided.
:- linkx(X) ; not specx(X) ; not impl(X) ; not sharx(X).
:- linky(Y) ; not specy(Y) ; not impl(Y) ; not shary(Y).
% Differential: X (Y) is invalid because shared but not implied in other concept.
:- sharx(X) ; not impl(X).
:- shary(Y) ; not impl(Y).
% Specificity: X (Y) is invalid because specific and implied in other concept.
:- specx(X) ; impl(X).
:- specy(Y) ; impl(Y).



% hold(X,Y):- rel(X,Y) ; not specx(X) ; specy(Y).
% ok(X):- rel(_,Z) ; not specy(Z) ; rel(X,Z) ; hold(X,_).
% :- hold(X,_) ; not ok(X).

% hold(X,Y):- rel(X,Y) ; not specy(Y) ; specx(X).
% ok(Y):- rel(Z,_) ; not specx(Z) ; rel(Z,Y) ; hold(_,Y).
% :- hold(_,Y) ; not ok(Y).

% A node is either in or out (possibly none of them), but not both.
% Following constraints are redundants.
:- specx(X) ; sharx(X).
:- specy(Y) ; shary(Y).

% Nodes involved in another concept.
inv(X):- rel(X,Z) ; not specy(Z).
inv(Y):- rel(Z,Y) ; not specx(Z).

% Objects are either inside, or in relation with the inside only.
ok(X):- specx(X).
ok(X):- sharx(X) ; not inv(X).
ok(X):- not sharx(X) ; not specx(X) ; rel(X,_).
:- not ok(X) ; rel(X,_).

% Same for attributes.
ok(Y):- specy(Y).
ok(Y):- shary(Y) ; not inv(Y).
ok(Y):- not shary(Y) ; not specy(Y) ; rel(_,Y).
:- not ok(Y) ; rel(_,Y).

#show.
#show specobj(X): specx(X).  % specific objects
#show specatt(Y): specy(Y).  % specific attributes
% #show specx/1.  % specific objects
% #show specy/1.  % specific attributes
% #show sharx/1.  % shared objects
% #show shary/1.  % shared attributes
% #show impl/1.
% #show linkx/1.
% #show linky/1.
