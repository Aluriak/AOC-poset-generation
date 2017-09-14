% This methods is looking for AOC poset.
% This methods do not works if objects and attributes share common items.
%
% Call
% cd C:\Users\jnicolas\Documents\potsdam\ASP\PowerGraphLucas\diff
%   ..\..\bin\clingopyth52.exe --stats reducedconceptsearch.lp partial_overlap.lp -n 0
%   ..\..\bin\clingopyth52.exe --stats reducedconceptsearch.lp five.lp -n 0
%

rel(X,Y):- edge(X,Y).

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
imp(X):- obj(X) ; int(Y) ; not rel(X,Y).
imp(Y):- ext(X) ; att(Y) ; not rel(X,Y).

%Equivalence of elements.
imp(X):- ext(U) ; not rel(U,Y) ;  rel(X,Y).
imp(Y):- int(V) ; not rel(X,V) ;  rel(X,Y).

imp(U):- obj(U); ext(X) ; not rel(U,Y) ;  rel(X,Y).
imp(V):- att(V); int(Y) ; not rel(X,V) ;  rel(X,Y).

%Non implied elements
imp(X):- impliesa(Y2,Y1); int(Y1) ;  rel(X,Y2).
imp(Y):- implieso(X2,X1); ext(X1) ;  rel(X2,Y).


:- ext(X) ; imp(X).
:- int(Y) ; imp(Y).
:- not ext(X) ; not imp(X) ; obj(X).
:- not int(Y) ; not imp(Y) ; att(Y).


#show.
%#show imp/1.
%#show implieso/2. #show impliesa/2.
#show specatt(Y): int(Y).
#show specobj(X): ext(X).

