testerSucces( Id, Commande ) :- 
	\+ Commande -> 
	(
	  write( "  -- " ),
      write( Id ),
	  write( " - N'a pas reussi : " ),
	  write( Commande ),
	  nl
	)
	; true
.

testerEchec( Id, Commande ) :-
    Commande ->
	(
	  write( "  -- " ),
      write( Id ),
	  write( " - Ne devrait pas réussir : " ),
	  write( Commande ),
	  nl
	)
	; true
.

effacer :-
	retractall( representant( _ ) ),
	retractall( estUn( _, _ ) )
.

test( creerClasse ) :-
    effacer,
	testerSucces( 'test 1', ( creerClasse( ca ), 
	                representant( ca ) ) ),
    testerSucces( 'test 2', ( creerClasse( cb ), 
	                representant( cb ) ) ),
    testerEchec( 'test 3', creerClasse( ca ) ),
    testerEchec( 'test 4', creerClasse( cb ) )
.

test( ajouterDansClasse ) :-
	effacer,
	testerEchec( 'test 1', ajouterDansClasse( [ a ], ca ) ),
	creerClasse( ca ),
	testerSucces( 'test 2', ( ajouterDansClasse( [ a ], ca ), 
	                estUn( a, ca ) ) ),
    testerEchec( 'test 3', ajouterDansClasse( [ b ], c ) ),
	testerEchec( 'test 4', ajouterDansClasse( [ b, a ], ca ) ),
	testerEchec( 'test 5', ajouterDansClasse( [ a, b ], ca ) ),
	testerSucces( 'test 6', ( ajouterDansClasse( [ e, f, g ], ca ),
	                estUn( e, ca ),
					estUn( f, ca ),
					estUn( g, ca ) ) ),
	testerSucces( 'test 7', ( ajouterDansClasse( [ h, i, j ], a ),
	                estUn( h, a ),
					estUn( i, a ),
					estUn( j, a ) ) )
.

test( profondeur ) :-
    effacer,
	creerClasse( ca ),
	testerSucces( 'test 1', profondeur( ca, 0 ) ),
	ajouterDansClasse( [ a1 ], ca ),
	testerSucces( 'test 2', profondeur( a1, 1 ) ),
	ajouterDansClasse( [ a2, a3 ], a1 ),
	testerSucces( 'test 3', profondeur( a2, 2 ) ),
	testerSucces( 'test 4', profondeur( a3, 2 ) ),
	ajouterDansClasse( [ a4, a5 ], a3 ),
	testerSucces( 'test 5', profondeur( a2, 2 ) ),
	testerSucces( 'test 6', profondeur( a3, 2 ) ),
	testerSucces( 'test 7', profondeur( a4, 3 ) ),
	testerSucces( 'test 8', profondeur( a5, 3 ) )
.

testTout :-
	forall( member( Nom, [ creerClasse, ajouterDansClasse, profondeur ] ),
	    (
		  write( "== " ),
		  write( test( Nom ) ),
		  write( " ==" ),
		  nl,
		  test( Nom )
		)
	)
.

