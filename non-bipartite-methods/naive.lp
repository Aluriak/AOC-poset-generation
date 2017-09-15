% Step 1: search for concepts.
% Step 2: filter their objects/attributes.

rel(X,Y):- edge(X,Y).
rel(X,Y):- edge(Y,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generation of concepts.
obj(X):- rel(X,_) ; rel(X,Y): att(Y).
att(Y):- rel(_,Y) ; rel(X,Y): obj(X).

% Avoid the empty concept.
:- not specatt(_) ; not specobj(_).



% Is outsider any object or attribute that is linked to attribute or object not in concept.
outsider_obj(X):- obj(X) ; rel(X,Z) ; not att(Z).
outsider_att(Y):- att(Y) ; rel(Z,Y) ; not obj(Z).

% We seek for specobj and specatt, the specific part of each concept.
specobj(X):- obj(X) ; not outsider_obj(X).
specatt(Y):- att(Y) ; not outsider_att(Y).


#show.
#show specobj/1.
#show specatt/1.
