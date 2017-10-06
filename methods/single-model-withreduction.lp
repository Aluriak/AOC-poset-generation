% This methods is looking for concepts in reduced form : the AOC poset
% This methods yield all aocposet in one answer set, using the aocposet/2 atoms.
% Note that the output is not previsible
%  if there is nodes with equivalences.

%*
Call 
cd C:\Users\jnicolas\Documents\potsdam\ASP\PowerGraphLucas\diff
  ..\..\bin\clingopyth52.exe --stats aocposet.lp simple.lp -n 0
  ..\..\bin\clingopyth52.exe --stats aocposet.lp partial_overlap.lp -n 0
  ..\..\bin\clingopyth52.exe --stats aocposet.lp partial_overlap0.lp -n 0
  ..\..\bin\clingopyth52.exe --stats aocposet.lp five.lp -n 0
  ..\..\bin\clingopyth52.exe --stats aocposet.lp structural_binding.lp -n 0
  ..\..\bin\clingopyth52.exe --stats aocposet.lp phosphatase.lp -n 0
  ..\..\bin\clingopyth52.exe --stats aocposet.lp bollobas_1000.lp -n 0
*%

rel(X,Y):- edge(X,Y).
rel(X,Y):- edge(Y,X).

obj(X):- rel(X,_).
att(Y):- rel(_,Y).


pair(X,Y):- rel(X,Y); not rel(Z,Y):obj(Z),Z!=X.
pair(X,Y):- rel(X,Y); not rel(X,Z):att(Z),Z!=Y.


aocposet(X,Y):- pair(X,Y).
aocposet(X,empty):- obj(X); not pair(X,Y): pair(X,Y).
aocposet(empty,Y):- att(Y); not pair(X,Y): pair(X,Y).


#show.
%#show pair/2. 
#show aocposet/2. 
