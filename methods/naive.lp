% Step 1: search for concepts.
% Step 2: filter their objects/attributes.

rel(X,Y):- edge(X,Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generation of concepts.
obj(X):- rel(X,_) ; rel(X,Y): att(Y).
att(Y):- rel(_,Y) ; rel(X,Y): obj(X).

% Avoid the empty concept.
:- not specatt(_) ; not specobj(_).



% Is outsider any object or attribute that is linked to attribute or object not in concept.
outsider(X):- obj(X) ; rel(X,Z) ; not att(Z).
outsider(Y):- att(Y) ; rel(Z,Y) ; not obj(Z).

% We seek for specobj and specatt, the specific part of each concept.
specobj(X):- obj(X) ; not outsider(X).
specatt(Y):- att(Y) ; not outsider(Y).


#show.
#show specobj/1.
#show specatt/1.
