% This methods is looking for AOC poset.
% This methods takes care of dissociating objects and attributes properly,
% in order to handle overlaps of these two sets.
%
% Call
% cd C:\Users\jnicolas\Documents\potsdam\ASP\PowerGraphLucas\diff
%   ..\..\bin\clingopyth52.exe --stats reducedconceptsearch.lp partial_overlap.lp -n 0
%   ..\..\bin\clingopyth52.exe --stats reducedconceptsearch.lp five.lp -n 0
%

rel(X,Y):- edge(X,Y).
rel(X,Y):- edge(Y,X).

obj(X):- rel(X,_).
att(Y):- rel(_,Y).

0 { ext(X): obj(X) }.  % objects
0 { int(Y): att(Y) }.  % attributes

%implication.
impliesobj(X1,X2):- obj(X1); obj(X2); X1!=X2; rel(X2,Y):rel(X1,Y).
impliesatt(Y1,Y2):- att(Y1); att(Y2); Y1!=Y2; rel(X,Y2):rel(X,Y1).
implieso(X1,X2):- impliesobj(X1,X2); not impliesobj(X2,X1). 
impliesa(Y1,Y2):- impliesatt(Y1,Y2); not impliesatt(Y2,Y1). 

% Consistency.
impobj(X):- obj(X) ; int(Y) ; not rel(X,Y).
impatt(Y):- ext(X) ; att(Y) ; not rel(X,Y).

%Equivalence of elements.
impobj(X):- ext(U) ; not rel(U,Y) ;  rel(X,Y).
impatt(Y):- int(V) ; not rel(X,V) ;  rel(X,Y).

impobj(U):- obj(U); ext(X) ; not rel(U,Y) ;  rel(X,Y).
impatt(V):- att(V); int(Y) ; not rel(X,V) ;  rel(X,Y).

%Non implied elements
impobj(X):- impliesa(Y2,Y1); int(Y1) ;  rel(X,Y2).
impatt(Y):- implieso(X2,X1); ext(X1) ;  rel(X2,Y).


:- ext(X) ; impobj(X).
:- int(Y) ; impatt(Y).
:- not ext(X) ; not impobj(X) ; obj(X).
:- not int(Y) ; not impatt(Y) ; att(Y).


#show.
%#show impobj/1.
%#show impatt/1.
%#show implieso/2. #show impliesa/2.
#show specatt(Y): int(Y).
#show specobj(X): ext(X).

