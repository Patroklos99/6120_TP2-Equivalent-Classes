:- dynamic( representant/1 ).
:- dynamic( estUn/2 ).

%------------------------------
% Constructeurs

% creerClasse( +Rep ).
% Construits une nouvelle classe d'équivalence (representant/1).
% - Si l'identificateur est présent dans une classe d'équivalence,
% alors affiche une erreur et lance un échec.  
% Ce prédicat réussi une seule fois.
% @param Rep le représentant de la classe d'équivalence
creerClasse(Rep) :-
    (representant(Rep) ; estUn(Rep, _)) ->
    (write('Error, lidentificateur est déjà présent dans une classe d\'équivalence.'), fail)
    ;
    assertz(representant(Rep)).

% ajouterDansClasse( +Ids, +IdRep ).
% Ajoute des identificateurs dans la meme  classe d'équivalence qu'un autre même classe d'équivalence qu'un autre
% Ce prédicat réussi une seule fois.
% @param Ids la liste des identificateurs à ajouter. 
% Ces identificateurs ne doivent pas être présents dans une classe d'équivalence.
%            Sinon : message d'erreur et échec.
%@param IdRep l'identificateur relié par les identifacateurs de la liste 'Ids'.  
% Cet identificateur doit être présent dans une classe d'équivalence.
%             Sinon : message d'erreur et échec.
ajouterDansClasse([], _).
ajouterDansClasse([Id|Ids], IdRep) :-
    (representant(Id) ; estUn(Id, _)) ->
    (write('Error: Identificateur déjà présent dans une classe d\'equivalence.'), fail)
    ;
    (representant(IdRep) ; estUn(IdRep, _)) ->
    (assertz(estUn(Id, IdRep)), ajouterDansClasse(Ids, IdRep))
    ;
    (write('Error: Identificateur Rep non présent dans une classe d\'equivalence.'), fail).

% joindre( +Id1, +Id2 ).
% Joins les deux classes d'équivalence.
% Si Id1 ou Id2 n'existe pas : message d'erreur.
% - Trouve les représentants. 
% Le représentant de la classe la moins haute est relié au représentant de la classe la plus haute.
%   (Ajouter un 'estUn/2', 
%    enlever un 'representant/1'.)
joindre(Id1, Id2) :-
    \+ ((representant(Id1) ; estUn(Id1, _)), (representant(Id2) ; estUn(Id2, _))) ->
    (write('Erreur: Identificateurs non présents dans une classe d\'équivalence.'), fail)
    ;
    trouver_representant(Id1, Rep1),
    trouver_representant(Id2, Rep2),
    (Rep1 == Rep2 -> true
    ;
    profondeur(Rep1, P1),
    profondeur(Rep2, P2),
    (P1 < P2 ->
        (retract(representant(Rep2)), assertz(estUn(Rep2, Rep1)))
    ;
        (retract(representant(Rep1)), assertz(estUn(Rep1, Rep2)))
    )).

% Trouver le représentant d'un identificateur
trouver_representant(Id, Rep) :-
    (representant(Id) -> Rep = Id
    ;
    (estUn(Id, Parent), trouver_representant(Parent, Rep))
    ).






%-------------------------------
% Prédicats de consultation


% equivalent( ?Id1, ?Id2 ).
% Vérifie que Id1 appartient à la même classe d'équivalence que Id2.
equivalent(Id1, Id2) :-
    trouver_representant(Id1, Rep1),
    trouver_representant(Id2, Rep2),
    Rep1 == Rep2.

% commun( ?Id1, ?Id2, ?L ).
% Ce prédicat donne vrai si 'L' est sur le chemin entre 'Id1' et son représentant ET
% si 'L' est sur le chemin entre 'Id2' et son représentant.
commun(Id1, Id2, L) :-
    chemin(Id1, Chemin1),
    chemin(Id2, Chemin2),
    member(L, Chemin1),
    member(L, Chemin2).

% profondeur( +Id, -N ).
% Retourne la profondeur 'N' de 'Id' dans sa classe d'équivalence. Si 'Id' est le représentant, alors
% il a une profondeur de 0. Sinon, la profondeur de 'Id' est le nombre de 'estUn' nécessaire pour trouver le représentant.
profondeur(Id, N) :-
    profondeur(Id, 0, N).

profondeur(Id, N, N) :-
    representant(Id).
profondeur(Id, Acc, N) :-
    estUn(Id, Parent),
    Acc1 is Acc + 1,
    profondeur(Parent, Acc1, N).

% pMoyenne( -M ).
% Retourne la moyenne de la profondeur de toutes les valeurs dans toutes les classes d'équivalences.
pMoyenne(M) :-
    findall(Id, (representant(Id); estUn(Id, _)), Ids),
    length(Ids, Total),
    sum_profondeurs(Ids, Sum),
    M is Sum / Total.

% Trouver le chemin jusqu'au représentant pour un identificateur
chemin(Id, [Id|Chemin]) :-
    (representant(Id) -> Chemin = []
    ;
    (estUn(Id, Parent), chemin(Parent, Chemin))
    ).

% Calculer la somme des profondeurs pour une liste d'identificateurs
sum_profondeurs([], 0).
sum_profondeurs([Id|Ids], Sum) :-
    profondeur(Id, N),
    sum_profondeurs(Ids, Rest),
    Sum is N + Rest.


%representant(a).
%representant(g).
%estUn(c, a).
%estUn(h, a).
%estUn(f, h).
%estUn(t, f).
%estUn(e, g).
%estUn(b, g).
%estUn(k, g).
%estUn(i, b).
