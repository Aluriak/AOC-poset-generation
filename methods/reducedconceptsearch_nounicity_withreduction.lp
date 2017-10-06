% This methods is looking for concepts in reducted form

%*
Call 
cd C:\Users\jnicolas\Documents\potsdam\ASP\PowerGraphLucas\diff
  ..\..\bin\clingopyth52.exe --stats reducedconceptsearchjack.lp partial_overlap.lp -n 0
  ..\..\bin\clingopyth52.exe --stats reducedconceptsearchjack.lp five.lp -n 0
  ..\..\bin\clingopyth52.exe --stats reducedconceptsearchjack.lp structural_binding.lp -n 0
*%

rel(X,Y):- edge(X,Y).
rel(X,Y):- edge(Y,X).

obj(X):- rel(X,_).
att(Y):- rel(_,Y).

%Equivalence between objects or attributes.
equivo(X1,X2):- obj(X1); obj(X2); X1<X2; rel(X1,Y):rel(X2,Y); rel(X2,Y):rel(X1,Y). 
equiva(Y1,Y2):- att(Y1); att(Y2); Y1<Y2; rel(X,Y1):rel(X,Y2); rel(X,Y2):rel(X,Y1). 

%Representatives of each equivalence class
omin(X):- obj(X); not equivo(_,X).
amin(Y):- att(Y); not equiva(_,Y).

%Strict implication between objects or attributes.
implieso(X1,X2):- omin(X1); omin(X2); X1!=X2; rel(X2,Y):rel(X1,Y). 
impliesa(Y1,Y2):- amin(Y1); amin(Y2); Y1!=Y2; rel(X,Y2):rel(X,Y1). 

{ ext(X): omin(X) }1.  % min object 
ext:-ext(X).

{ int(Y): amin(Y), rel(X,Y) }1:- ext(X).  % min attribute
{ int(Y): amin(Y)}1:- not ext.

spec(att,Y):- int(Y).
spec(att,Z):- int(Y); equiva(Y,Z).
spec(obj,X):- ext(X).
spec(obj,Z):- ext(X); equivo(X,Z).


%Impossible elements.
impo(X):- omin(X); ext(U); X!=U.
impa(Y):- amin(Y); int(V); Y!=V.

impo(X):- int(Y); impliesa(V,Y); rel(X,V); omin(X).
impa(Y):- ext(X); implieso(U,X); rel(U,Y); amin(Y).

% Consistency.
:- ext(X) ; impo(X).
:- int(Y) ; impa(Y).

% Maximality.
:- not ext(X) ; not impo(X) ; omin(X).
:- not int(Y) ; not impa(Y) ; amin(Y).


#show.
%#show implieso/2. #show impliesa/2.
%#show equivo/2. #show equiva/2.
%#show impo/1. #show impa/1.
#show specobj(X): spec(obj,X).
#show specatt(Y): spec(att,Y).
