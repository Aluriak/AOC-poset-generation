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

%Representatives of each equivalence class
omin(X):- obj(X); not equivo(_,X).
amin(Y):- att(Y); not equiva(_,Y).

%Strict implication between objects or attributes.
implieso(X1,X2):- obj(X1); obj(X2); X1!=X2; rel(X2,Y):rel(X1,Y). 
impliesa(Y1,Y2):- att(Y1); att(Y2); Y1!=Y2; rel(X,Y2):rel(X,Y1). 

{ ext(X): obj(X) }1.  % min object 
ext:-ext(X).

{ int(Y): att(Y), rel(X,Y) }1:- ext(X).  % min attribute
{ int(Y): att(Y)}1:- not ext.

spec(att,Y):- int(Y).
spec(obj,X):- ext(X).


%Impossible elements.
impo(X):- obj(X); ext(U); X!=U.
impa(Y):- att(Y); int(V); Y!=V.

impo(X):- int(Y); impliesa(V,Y); rel(X,V); obj(X).
impa(Y):- ext(X); implieso(U,X); rel(U,Y); att(Y).

% Consistency.
:- ext(X) ; impo(X).
:- int(Y) ; impa(Y).

% Maximality.
:- not ext(X) ; not impo(X) ; obj(X).
:- not int(Y) ; not impa(Y) ; att(Y).


#show.
%#show implieso/2. #show impliesa/2.
%#show equivo/2. #show equiva/2.
%#show impo/1. #show impa/1.
#show specobj(X): spec(obj,X).
#show specatt(Y): spec(att,Y).
