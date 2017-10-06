% Step 1: search for concepts.
% Step 2: filter their objects/attributes.

rel(X,Y):- edge(X,Y).
rel(X,Y):- edge(Y,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generation of concepts.
ext(X):- rel(X,_) ; rel(X,Y): int(Y).
int(Y):- rel(_,Y) ; rel(X,Y): ext(X).


% Is outsider any object or attribute that is linked to attribute or object not in concept.
outsider_ext(X):- ext(X) ; rel(X,Z) ; not int(Z).
outsider_int(Y):- int(Y) ; rel(Z,Y) ; not ext(Z).

% % We seek for specobj and specatt, the specific part of each concept.
specext(X):- ext(X) ; not outsider_ext(X).
specint(Y):- int(Y) ; not outsider_int(Y).


% Avoid the empty concept.
:- not int(_) ; not ext(_).


#show.
#show specobj(X): specext(X).
#show specatt(Y): specint(Y).
% #show int/1.
% #show ext/1.
