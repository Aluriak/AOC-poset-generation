% This methods do not search for concepts.


obj(X):- rel(X,_).
att(Y):- rel(_,Y).


0 { ext(X): obj(X) }.  % X
0 { int(Y): att(Y) }.  % Y


% Consistency.
imp(X):- obj(X) ; int(Y) ; not rel(X,Y).
imp(Y):- ext(X) ; att(Y) ; not rel(X,Y).


% X' and Y'.
derobj(X):- obj(X) ; rel(X, Y): int(Y).
deratt(Y):- att(Y) ; rel(X, Y): ext(X).


% complement of X' and Y'.
cmpobj(X):- obj(X) ; not derobj(X).
cmpatt(Y):- att(Y) ; not deratt(Y).

% Avoid attribute (object) in relation with complement of X' (Y').
imp(Y):- cmpobj(X) ; rel(X,Y).
imp(X):- cmpatt(Y) ; rel(X,Y).

:- ext(X) ; imp(X).
:- int(Y) ; imp(Y).
:- not ext(X) ; not imp(X) ; obj(X).
:- not int(Y) ; not imp(Y) ; att(Y).


#show.
#show specatt(Y): int(Y).
#show specobj(X): ext(X).
% #show imp/1.
