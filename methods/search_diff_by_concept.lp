% Another try to generate differential notation for concepts.
% Here, we generate the concepts, then filter their "shared with other" subparts.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST CASES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple case : overlap is {a,b}×{e,f}
% rel((a;b;c;d),(e;f)).
% rel((a;b),(g;h)).
% Expected: {a,b}×{g,h}, {c,d}×{e,f}

% Twoside case : overlap is {a,b,c,d}×{g,h}
% This is a particular case: the overlap is partial (not all attributes or objects of concepts are implied).
% rel((1;2),(a;b;c;d)).
% rel((3;4),(c;d;e;f)).
% Expected: {}×{c,d}, {3,4}×{e,f}, {1,2}×{a,b}

% Two independants case : overlaps are {a,b}×{g,h} and {a2,b2}×{e2,f2}
% rel((1;2;3;4),(a;b)).
% rel((1;2),(c;d)).
% rel((5;6;7;8),(e;f)).
% rel((5;6),(g;h)).
% Expected: {5,6}×{g,h}, {7,8}×{e,f}, {1,2}×{c,d}, {3,4}×{a,b}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generation of concepts.
obj(X):- rel(X,_) ; rel(X,Y): att(Y).
att(Y):- rel(_,Y) ; rel(X,Y): obj(X).
% Avoid (half) empty concepts.
:- not obj(X): obj(X).
:- not att(Y): att(Y).



% Is outsider any object or attribute that is linked to attribute or object not in concept.
not_obj(Z):- not obj(Z) ; rel(Z,_).
not_att(Z):- not att(Z) ; rel(_,Z).
outsider(X):- obj(X) ; rel(X,Z) ; not_att(Z).
outsider(Y):- att(Y) ; rel(Z,Y) ; not obj(Z).

% We seek for specobj and specatt, the specific part of each concept.
specobj(X):- obj(X) ; not outsider(X).
specatt(Y):- att(Y) ; not outsider(Y).


#show.
#show specobj/1.
#show specatt/1.
% #show obj/1.
% #show att/1.
% #show outsider/1.
