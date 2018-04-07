// Materia: Introduccion a la Algoritmica y Programacion 2016
// Proyecto fin de año "Juego PasaPalabra".
// Comisión n°2 - Grupo n°7
// Integrantes:
// - Elena, Pablo.
// - Gremiger, Santiago.
// - Martinez, Christian.
// **********************

// Unit dedicada al manejo de los puntajes.

unit unitPuntaje;

interface
uses
	unitInterfaz,unitTipos,crt;

{======================================================================================}
{Declaraciones de las acciones y funciones visibles para quienes utilizan esta unidad}

{Inicializa el archivo "puntajes.dat" y lo prepara para su uso}
procedure inicalizar_puntajes(var f: TfilePuntajes);

{Modulo que guarda el usuario, el puntaje y la dificultad en el archivo}
procedure guardar_puntaje(var f: TfilePuntajes; dat: TDatosJuego);

{Modulo que muestra el promedio de los puntajes del usuario actual}
procedure promedio_usuario(var f: TfilePuntajes; user: TListaUsuarios);

{Carga todos los puntajes y muestra los 10 mejores por pantalla}
procedure mejores_puntajes(var f: TfilePuntajes);

{======================================================================================}
{Implementación del Módulo}
implementation

{******************************************************************************************}
{********** Declaracion de Acciones y Funciones Auxiliares locales al módulo **************}
{******************************************************************************************}

{Inicializa la LSE que contiene los puntajes}
procedure inicializar_listaPuntajes(var p: TPunt_TListaPuntajes); forward;

{Crea un nuevo nodo para la lista que contiene los puntajes}
procedure nuevo_nodoPuntaje(var p: TPunt_TListaPuntajes; puntaje: TPuntaje); forward;

{Libera todos los nodos de la LSE de los puntajes}
procedure liberar_listaPuntajes(var p: TPunt_TListaPuntajes); forward;

{Modulo que carga los puntajes desde el archivo "puntajes.dat" y los carga de forma decreciente en una LSE}
procedure cargar_puntajes(var f: TfilePuntajes; var listaPuntaje: TPunt_TListaPuntajes); forward;

{Devuelve el promedio de puntajes del usuario}
function promedio(lista: TPunt_TListaPuntajes; user: TListaUsuarios; cant: integer; sumatoria: integer): integer; forward;

{Modulo que imprime los 10 mejores puntajes en pantalla}
procedure impr_puntajes(listaPuntaje: TPunt_TListaPuntajes); forward;


{******************************************************************************************}
{************************ Implementación de Acciones y Funciones Exportadas ***************}
{******************************************************************************************}

{Inicializa el archivo "puntajes.dat" y lo prepara para su uso}
procedure inicalizar_puntajes(var f: TfilePuntajes);
begin
	assign(f,'puntajes.dat');
	{$I-}
	reset(f);
	{$I+}
	if IOResult<>0 then
		rewrite(f);
end;

{Modulo que guarda el usuario, el puntaje y la dificultad en el archivo}
procedure guardar_puntaje(var f: TfilePuntajes; dat: TDatosJuego);
var
	punt: TPuntaje;
begin
	punt.nombre := dat.user; //Copia el nombre usuario.
	punt.puntaje := dat.punt_act; //Copia el puntaje.
	punt.dif:= dat.dif; //Copia la dificultad.
	reset(f);
	seek(f,filesize(f));
	write(f,punt);
	close(f);
end;

{Modulo que muestra el promedio de los puntajes del usuario actual}
procedure promedio_usuario(var f: TfilePuntajes; user: TListaUsuarios);
var
	lstPunt: TPunt_TListaPuntajes;
	prom: integer;
begin
	clrscr;
	reset (f);
	impr_bordes();
	logo();
	if filesize(f)=0 then begin//El archivo "puntajes.dat" no tiene ningun valor almacenado.
		impr_promedio(user,-1);
		close(f);
	end
	else begin
		cargar_puntajes(f,lstPunt);
		prom := promedio((lstPunt^).next,user,0,0);
		impr_promedio(user,prom);
		liberar_listaPuntajes(lstPunt);
	end;
	readkey;
end;

{Carga todos los puntajes y muestra los 10 mejores por pantalla}
procedure mejores_puntajes(var f: TfilePuntajes);
var
	lstPunt: TPunt_TListaPuntajes;
begin
	clrscr;
	reset(f);
	if (filesize(f)=0) then begin//El archivo "puntajes.dat" no tiene ningun valor almacenado.
		impr_bordes();
		gotoxy(25,17);
		seleccion_error('ERROR: No existen puntajes cargados');
		close(f);
	end
	else begin
		cargar_puntajes(f,lstPunt);
		impr_puntajes(lstPunt);
		liberar_listaPuntajes(lstPunt);
	end;
  readkey;
end;

{******************************************************************************************}
{********** Implementación de Acciones y Funciones Auxiliares locales al módulo ***********}
{******************************************************************************************}

{Crea un nuevo nodo para la lista que contiene los puntajes}
procedure nuevo_nodoPuntaje(var p: TPunt_TListaPuntajes; puntaje: TPuntaje);
begin
	new(p);
	(p^).usuario := puntaje;
	(p^).next := nil;
end;

{Inicializa la LSE que contiene los puntajes}
procedure inicializar_listaPuntajes(var p: TPunt_TListaPuntajes);
begin
	//Utiliza elemento ficticio.
	new(p);
	(p^).next := nil;
end;

{Libera todos los nodos de la LSE de los puntajes}
procedure liberar_listaPuntajes(var p: TPunt_TListaPuntajes);
var
	pAux: TPunt_TListaPuntajes;
begin
	while (p<>nil) do begin
		pAux := p;
		p := (p^).next;
		dispose(pAux);
	end;
end;

{Modulo que carga los puntajes desde el archivo "puntajes.dat" y los carga de forma decreciente en una LSE}
procedure cargar_puntajes(var f: TfilePuntajes; var listaPuntaje: TPunt_TListaPuntajes);
var
	punt: TPuntaje;
	pNuevo, pAux: TPunt_TListaPuntajes;
begin
	reset(f);
	inicializar_listaPuntajes(listaPuntaje);
	read(f,punt);
	nuevo_nodoPuntaje(pNuevo,punt);
	(listaPuntaje^).next:=pNuevo; //Inserta el primer puntaje en la lista;
	while (not(EOF(f))) do begin
		read(f,punt);
        pAux:=listaPuntaje;
        //pAux avanza hasta encontrar un puntaje menor a "punt.puntaje".
		while ((pAux^).next<>nil) and (punt.puntaje<=((pAux^).next^).usuario.puntaje) do begin
			pAux:= (pAux^).next;
		end;
		nuevo_nodoPuntaje(pNuevo,punt);
		//Inserta "punt.punaje" despues de pAux.
		(pNuevo^).next:= (pAux^).next;
		(pAux^).next:= pNuevo;
	end;
	close(f);
end;

{Devuelve el promedio de puntajes del usuario}
function promedio(lista: TPunt_TListaPuntajes; user: TListaUsuarios; cant: integer; sumatoria: integer): integer;
begin
	if (lista=nil) then begin
        if cant<>0 then
          promedio := (sumatoria div cant)
        else
		promedio := 0
	end
	else
		if ((lista^).usuario.nombre = user) then
			promedio := promedio((lista^).next, user, cant+1, sumatoria + (lista^).usuario.puntaje)
		else
			promedio := promedio((lista^).next, user, cant, sumatoria);
end;

{Modulo que imprime los 10 mejores puntajes en pantalla}
procedure impr_puntajes(listaPuntaje: TPunt_TListaPuntajes);
var
	pAux: TPunt_TListaPuntajes;
	x,y,i: integer;
begin
	i:= 1;
	x:= 15;
	y:= 8;
	impr_bordes();
	pAux:= (listaPuntaje^).next;
	//Cabecera de los puntajes
		gotoxy(33,5);
		textcolor(texto_titulo);
		write('=== TOP 10 PUNTAJES ===');
		textcolor(color_logo);
		gotoxy(x,y);
		write('N°');
		gotoxy(x+7,y);
		write('NOMBRE');
		gotoxy(x+35,y);
		write('PUNTAJE');
		gotoxy(x+50,y);
		write('DIFICULTAD');
		textcolor(white);
	//Fin cabecera
	textcolor(texto_base);
	while ((i<=10) and(pAux <> nil)) do begin
		y:= y+2;
		gotoxy(x,y);
		write(i);
		gotoxy(x+6,y);
		write((pAux^).usuario.nombre);
		gotoxy(x+36,y);
		write((pAux^).usuario.puntaje);
		gotoxy(x+50,y);
        case (pAux^).usuario.dif of //Segun el tipo, escribe la dificultad
        	facil: write('Facil');
        	dificil: write('Dificil');
        end;
		pAux:= (pAux^).next;
		i:= i + 1;
	end;
end;

end.
