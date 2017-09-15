% This methods is looking for concepts in reducted form

%*
Call 
cd C:\Users\jnicolas\Documents\potsdam\ASP\PowerGraphLucas\diff
  ..\..\bin\clingopyth52.exe --stats reducedconceptsearch.lp partial_overlap.lp -n 0
  ..\..\bin\clingopyth52.exe --stats reducedconceptsearch.lp five.lp -n 0
*%

rel(X,Y):- edge(X,Y).
rel(X,Y):- edge(Y,X).
obj(X):- rel(X,_).
att(Y):- rel(_,Y).

0 { ext(X): obj(X) }.  % objects
0 { int(Y): att(Y) }.  % attributes

%Strict implication between objects or attributes.
implieso(X1,X2):- obj(X1); obj(X2); X1!=X2; rel(X2,Z); not rel(X1,Z); rel(X2,Y):rel(X1,Y). 
impliesa(Y1,Y2):- att(Y1); att(Y2); Y1!=Y2; rel(Z,Y2); not rel(Z,Y1); rel(X,Y2):rel(X,Y1). 

%Conditions of impossibility
%---------------------------

% Biclique.
impo(X):- obj(X); int(Y); not rel(X,Y).
impa(Y):- ext(X); att(Y); not rel(X,Y).

%Equivalence of elements.
impo(X):- ext(U) ; not rel(U,Y) ;  rel(X,Y).
impa(Y):- int(V) ; not rel(X,V) ;  rel(X,Y).

impo(U):- obj(U); ext(X) ; not rel(U,Y) ;  rel(X,Y).
impa(V):- att(V); int(Y) ; not rel(X,V) ;  rel(X,Y).

%Non implied elements
impo(X):- impliesa(Y2,Y1); int(Y1) ;  rel(X,Y2).
impa(Y):- implieso(X2,X1); ext(X1) ;  rel(X2,Y).

%Use of impossibility contraints
%-------------------------------

% Consistency.
:- ext(X) ; impo(X).
:- int(Y) ; impa(Y).
% Maximality.
:- not ext(X) ; not impo(X) ; obj(X).
:- not int(Y) ; not impa(Y) ; att(Y).

#show.
%#show impliesobj/2. #show impliesatt/2.
%#show implieso/2. #show impliesa/2.
%#show impo/1. #show impa/1.
#show specatt(Y): int(Y).
#show specobj(X): ext(X).
