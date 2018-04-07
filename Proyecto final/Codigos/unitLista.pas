// Materia: Introduccion a la Algoritmica y Programacion 2016
// Proyecto fin de año "Juego PasaPalabra".
// Comisión n°2 - Grupo n°7
// Integrantes:
// - Elena, Pablo.
// - Gremiger, Santiago.
// - Martinez, Christian.
// **********************

// Unit dedicada al manejo de las LSE.

unit unitLista;

Interface
uses
	unitTipos;

{======================================================================================}
{Declaraciones de las acciones y funciones visibles para quienes utilizan esta unidad}

{Retorna un Puntero al primer elemento valido de la Lista, Fin(l) si esta vacia}
function Inicio( l : TLista ) : TPuntero;

{Retorna un Puntero al primer elemento no valido de la Lista}
function Fin ( l : TLista ) : TPuntero;

{Retorna un Puntero al ultimo elemento valido de la Lista, Fin(l) si esta vacia}
function Ultimo (l : TLista) : TPuntero;

{Retorna el puntero al siguiente elemento de un elemento valido}
{pre: pos <> nil}
function Siguiente(pos : TPuntero ) : TPuntero;

{Retorna True si la Lista esta vacia, falso en caso contrario}
function EsVacia( l : TLista ) : boolean;

{Retorna el valor del elemento que corresponde a un Puntero }
{pre: pos <> nil}
function Obtener( pos : TPuntero) : TInfo;

{Retorna la longitud de la Lista }
function Longitud( l : TLista ) : integer;

{Inicializa la Lista como vacia }
procedure Inicializar( var l : TLista );

{Modifica el elemento que esta en un Puntero }
{pre: pos <> nil}
procedure Modificar( e : TInfo; var pos : TPuntero);

{Inserta un elemento al principio de la Lista }
procedure InsertarAlInicio(  e : TInfo; var l : TLista);

{Inserta un elemento al final de la Lista }
procedure InsertarAlFinal(  e : TInfo;  var l : TLista);

{Inserta un elemento en una posicion dada}
procedure InsertarEnPos(e: TInfo; var l: TLista; pos: integer);

{Elimina el primer elemento de la Lista}
{pre: Longitud(l) >= 1 }
procedure EliminarPrincipio(var l : TLista);

{Elimina el elemento que se encuentra en la posicion dada}
{pre: pos <= Loncitud(l)}
procedure EliminarEnPos(var l: TLista; pos: integer);

{Elimina el ultimo elemento de la Lista}
{pre: Longitud(l) >= 1 }
procedure EliminarFinal(var l : TLista);

{Controla si un elemento dado se encuentra en la lista}
function TieneElem(info: TInfo; l : TLista): boolean;

{Muestra los elementos de l}
procedure MostrarLista(l: TLista; todas: boolean);

{Verifica condiciones para que una accion/funcion funcione correctamente, de no ser asi, cierra el programa.}
procedure Verificar( cond : boolean; mensaje_error : string );

//Funciones para generar nivel(temporales)

{modifica el campo visible de un puntero de la lista}
procedure ocultar_letra(var l: TLista; pos: integer);

{Devuelve el caracter que se encuentra en la posicion dada}
function obtener_letra(var l: TLista; pos: integer):char;

{Retorna True si un caracter esta en una posicion determinada de la lista, falso de lo contrario}
function CheckEnPosCaracter(var l: TLista; pos: integer; car: char):boolean;

{Devuelve "true" si el campo ".visible" es true}
function CheckEnPosVisible(var l: TLista; pos: integer):boolean;


{======================================================================================}
{Implementación del Módulo}
Implementation
uses
	crt;
{******************************************************************************************}
{********** Declaracion de Acciones y Funciones Auxiliares locales al módulo **************}
{******************************************************************************************}


{Incrementa en 1 el campo cant de la lista }
procedure IncrementarCantidadElementos(var l : TLista); forward;

{Decrementa en 1 el campo cant de la lista }
procedure DecrementarCantidadElementos(var l : TLista); forward;

{Crea un nuevo Nodo de la Lista y le setea la informacion recibida como parametro}
procedure CrearNuevoNodo( var nuevoNodo : TPuntero; e: TInfo); forward;


{******************************************************************************************}
{************************ Implementación de Acciones y Funciones Exportadas ***************}
{******************************************************************************************}

{Retorna un Puntero al primer elemento valido de la Lista, Fin(l) si esta vacia}
function Inicio( l : TLista ) : TPuntero;
begin
	Inicio:= (l.pri^).next; //retorno el puntero que sigue al ficticio.
end;

{Retorna un Puntero al primer elemento no valido de la Lista}
function Fin ( l : TLista ) : TPuntero;
begin
	Fin := nil;
end;

{Retorna un Puntero al ultimo elemento valido de la Lista, Fin(l) si esta vacia}
function Ultimo (l : TLista) : TPuntero;
var
	pAux : TPuntero;
begin
	pAux := l.pri;
	while((pAux^).next <> nil)do begin
		pAux := Siguiente(pAux);
	end;
	Ultimo := pAux;
end;

{Retorna el puntero al siguiente elemento de un elemento valido}
{pre: pos <> nil}
function Siguiente(pos : TPuntero ) : TPuntero;
begin
	Verificar(pos <> nil,'No se puede obtener siguiente posicion. Puntero nulo.');
	Siguiente:=(pos^).next;
end;

{Retorna True si la Lista esta vacia, falso en caso contrario}
function EsVacia( l : TLista ) : boolean;
begin
  if l.cant=0 then
	EsVacia:=true
  else
	EsVacia:=false;
end;

{Retorna el valor del elemento que corresponde a un Puntero }
{pre: pos <> nil}
function Obtener( pos : TPuntero) : TInfo;
begin
	Verificar(pos <> nil,'No se puede obtener valor. Puntero nulo.');
	Obtener := (pos^).info;
end;

{Retorna la longitud de la Lista.}
function Longitud( l : TLista ) : integer;
begin
	longitud:=l.cant;
end;

{Inicializa la Lista como vacia.}
procedure Inicializar( var l : TLista );
begin
	//Utilizacion elemento ficticio.
	new(l.Pri);
	(l.Pri^).next := nil;
	l.Ult := l.Pri;
	l.cant := 0;
end;

{Modifica el elemento que esta en un Puntero.}
{pre: pos <> nil}
procedure Modificar (e:TInfo; var pos : TPuntero);
begin
	Verificar(pos <> nil,'No se puede modificar valor. Puntero nulo.');
	(pos^).info := e;
end;


{Inserta un elemento al principio de la Lista.}
procedure InsertarAlInicio(e:TInfo; var l : TLista);
begin
	InsertarEnPos(e,l,1);
end;

{Inserta un elemento en una posicion dada}
{pre: pos <= Longitud(l) && pos > 0}
procedure InsertarEnPos(e: TInfo; var l: TLista; pos: integer);
var
	n,pAux: TPuntero;
	i : integer;
begin
	Verificar(((0 < pos) and (pos <= Longitud(l)+1)),'No se puede Insertar. Posicion fuera de rango.');
	pAux:=l.pri; //Obtecion primer elemento.
	i := 1;
	while (i < pos) and (pAux <> nil) do begin
		i := i + 1;
		pAux := Siguiente(pAux);
	end;
	CrearNuevoNodo(n,e);
	(n^).next := (pAux^).next;
	(pAux^).next := n;
	IncrementarCantidadElementos(l);
	l.ult := Ultimo(l); //posiciona el puntero l.ult al ultimo elemento valido.
end;

{Inserta un elemento al final de la Lista }
procedure InsertarAlFinal(e:TInfo;  var l : TLista);
begin
	InsertarEnPos(e,l,l.cant+1);
end;

{ Elimina el primer elemento de la Lista}
{ pre: Longitud(l) >= 1 }
procedure EliminarPrincipio(var l : TLista);
begin
	EliminarEnPos(l,1);
end;

{Elimina el elemento que se encuentra en la posición dada}
{pre: pos <= Longitud(l) && pos > 0}
procedure EliminarEnPos(var l: TLista; pos: integer);
var
	pAux, pElim : TPuntero;
	i: integer;
begin
	Verificar(not(EsVacia(l)), 'La lista esta vacia no se puede Eliminar.');
	Verificar(((0 < pos) and (pos <= Longitud(l))),'No se puede Eliminar. Posicion fuera de rango.');
	pAux:=l.Pri; //Obtecion primer elemento.
	i := 0;
	while (i < pos-1) do begin
		i := i + 1;
		pAux := Siguiente(pAux);
	end;
	pElim := (pAux^).next;
	(pAux^).next := (pElim^).next;
	dispose(pElim);
	DecrementarCantidadElementos(l);
	l.ult := Ultimo(l); //posiciona el puntero l.ult al ultimo elemento valido.
end;

{Elimina el ultimo elemento de la Lista}
{ pre: Longitud(l) >= 1 }
procedure EliminarFinal(var l : TLista);
begin
	EliminarEnPos(l,l.cant);
end;

{Controla si un elemento dado se encuentra en la lista}
function TieneElem(info: TInfo; l : TLista): boolean;
var
	pAux: TPuntero;
	encontrado : boolean;
begin
	pAux := Inicio(l);
	encontrado := false;
	while ((pAux <> nil) and not(encontrado)) do begin
		if (Obtener(pAux).caracter = info.caracter) then
			encontrado := true
		else
			pAux := Siguiente(pAux);
	end;
	TieneElem := encontrado;
end;

{Muestra los elementos de l}
procedure MostrarLista(l: TLista; todas: boolean);
var
  r: Tpuntero;
begin
  Verificar(Not(EsVacia(l)), 'La lista esta vacia no se puede mostrar.');
  r:=Inicio(l);
  while r<>nil do begin
	if (((Obtener(r)).visible) or (todas)) then
	  write(' ',upcase((Obtener(r)).caracter))
	else
	write(' _');
	r:=Siguiente(r);
  end;
end;

{Oculta el caracter de la posicion dada}
procedure ocultar_letra(var l: TLista; pos: integer);
var
  pAux: TPuntero;
  i: integer;
begin
  Verificar((pos <= Longitud(l)+1)and(pos > 0),'La cantidad de elementos de la secuencia es menor a la posicion solicitada');
  pAux:=Inicio(l);
  i:=1;
  while i<pos do begin
	i:=i+1;
	pAux:=Siguiente(pAux);
  end;
  (pAux^).info.visible:=false;
end;

{Devuelve el caracter que se encuentra en la posicion dada}
function obtener_letra(var l: TLista; pos: integer):char;
var
  pAux: TPuntero;
  i: integer;
begin
   Verificar((pos <= Longitud(l)+1)and(pos > 0),'La cantidad de elementos de la secuencia es menor a la posicion solicitada');
   pAux:=Inicio(l);
   i:=1;
   while i<pos do begin
	i:=i+1;
	pAux:=Siguiente(pAux);
   end;
   obtener_letra:=(pAux^).info.caracter;
end;

{Devuelve "true" si el caracter de la posicion dada es igual al de la palabra}
function CheckEnPosCaracter(var l: TLista; pos: integer; car: char):boolean;
var
  pAux: TPuntero;
  i: integer;
begin
  Verificar((pos <= Longitud(l)+1)and(pos > 0),'La cantidad de elementos de la secuencia es menor a la posicion solicitada');
  pAux:=Inicio(l);
  i:=1;
  while i<pos do begin
	i:=i+1;
	pAux:=Siguiente(pAux);
  end;
  CheckEnPosCaracter := (pAux^).info.caracter=car;
end;

{Devuelve "true" si el campo ".visible" es true}
function CheckEnPosVisible(var l: TLista; pos: integer):boolean;
var
	s: TPuntero;
	i: integer;
begin
	Verificar((pos <= Longitud(l)+1)and(pos > 0),'La cantidad de elementos de la secuencia es menor a la posicion solicitada');
	s:=Inicio(l);
	i:=1;
	while i<pos do begin
		i:=i+1;
		s:=Siguiente(s);
  	end;
	CheckEnPosVisible := (s^).info.visible=true;
end;

{Verifica condiciones para que una accion/funcion funcione correctamente, de no ser asi, cierra el programa.}
procedure Verificar( cond : boolean; mensaje_error : string );
begin
	if (not cond) then
	begin
		writeln('ERROR: ', mensaje_error);
		halt;
	end;
end;

{******************************************************************************************}
{********** Implementación de Acciones y Funciones Auxiliares locales al módulo ***********}
{******************************************************************************************}

//--------------------------------------------------------
procedure IncrementarCantidadElementos(var l : TLista);
begin
	l.cant := l.cant + 1;
end;

//--------------------------------------------------------
procedure DecrementarCantidadElementos(var l : TLista);
begin
	l.cant := l.cant - 1;
end;


//--------------------------------------------------------
procedure CrearNuevoNodo( var nuevoNodo : TPuntero; e: TInfo);
begin
	new(nuevoNodo);
	(nuevoNodo^).info := e;
end;

end.
