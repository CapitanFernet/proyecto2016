// Materia: Introduccion a la Algoritmica y Programacion 2016
// Proyecto fin de año "Juego PasaPalabra".
// Comisión n°2 - Grupo n°7
// Integrantes:
// - Elena, Pablo.
// - Gremiger, Santiago.
// - Martinez, Christian.
// **********************

// Unit dedicada al manejo y funcionamiento del juego.

unit unitJuego;

interface
uses
	unitLista,unitTipos,unitUsuario,unitPuntaje,unitInterfaz,crt;

{======================================================================================}
{Declaraciones de las acciones y funciones visibles para quienes utilizan esta unidad}

{inicializa el archivo "palabras.dat"}
procedure inicializar_palabras(var f: TfilePalabra;var check:boolean);

{Inicializa el juego de "PasaPalabra"}
procedure iniciar_juego(user: TListaUsuarios; var fPunt: TfilePuntajes;var fUser: TfileUsuarios;var fPal: TfilePalabra);

{======================================================================================}
{Implementación del Módulo}
Implementation

{******************************************************************************************}
{********** Declaracion de Acciones y Funciones Auxiliares locales al módulo **************}
{******************************************************************************************}

{Inicializa los contadores de datos de la partida actual}
procedure inicializar_datosJuego(var d: TDatosJuego); forward;

{Funcion que dada una palabra te devuelve la misma cargada en una lista simplemente encadenada de caracteres}
function CargarPalabraEnLista(palStr: TPalabra ): TLista; forward;

{Genera la rosca con las 26 letras y sus respectivas palabras}
{Cada letra se le asigna aleatoriamente 1 palabra de las 5 dispobibles para dicha letra}
procedure generar_rosca(var f: TfilePalabra;var rosca: TRosca); forward;

{Modifica las palabras en la rosca, tapando cierta cantidad de letras por palabra segun la dificultad elegida}
procedure generar_palabrasRosca(var rosca: TRosca; dif: integer); forward;

{Menu que genera la dificultad en la rosca}
procedure dificultad(var rosca: TRosca; var dat: TDatosJuego); forward;

{Modulo que retorna "true" si la respuesta del usuario coincide con la palabra}
function comprobar_palabra(resp: string; pal: TLista): boolean; forward;

{Modulo que ejecuta la opcion "Jugar Palabra"}
procedure jugar_palabra(var rosca: TRosca;var dat: TDatosJuego); forward;

{Modulo que ejecuta la opcion "PasaPalabra"}
procedure jugar_pasaPalabra(var rosca: TRosca; var dat: TDatosJuego); forward;

{Juego principal}
procedure juego_rosca(var rosca: TRosca; var dat: TDatosJuego); forward;

{Libera todos los nodos de la LSE de la rosca }
procedure liberar_rosca(var r:TRosca); forward;

{******************************************************************************************}
{************************ Implementación de Acciones y Funciones Exportadas ***************}
{******************************************************************************************}

{Inicializa el archivo "palabras.dat"}
{Verifica que el archivo "palabras.dat" exista y no este vacio,en caso contrario devuelve un mensaje de error}
{La variable "check" sirve para cancelar el inicio del juego en caso de un error}
procedure inicializar_palabras(var f: TfilePalabra;var check:boolean);
begin
	assign(f,'palabras.dat');
	{$I-}
		reset(f);
	{$I+}
	if (IOResult<>0) then begin //Imprime un mensaje informando que el archivo no existe.
    	impr_bordes();
		gotoxy(22,17);
        seleccion_error('ERROR: EL ARCHIVO "palabras.dat" NO SE ENCUENTRA');
        check:=false;
        readkey;
    end
    else begin
		if (filesize(f)=0) then begin //Imprime un mensaje informando que el archivo no contenga palabras.
			impr_bordes();
			gotoxy(22,17);
			seleccion_error('ERROR: EL ARCHIVO "palabras.dat" ESTA VACIO');
			check:=false;
			readkey;
		end
    end;
end;

{Inicializa el juego de "PasaPalabra"}
procedure iniciar_juego(user: TListaUsuarios; var fPunt: TfilePuntajes;var fUser: TfileUsuarios;var fPal: TfilePalabra);
var
	dat: TDatosJuego;
	rosca: TRosca;
    check:boolean;
begin
	dat.user := user;
    check := true;
	inicializar_palabras(fPal,check);
    if check then begin //si no hay ningun problema con el archivo "palabras.dat" se continua con el juego
	  generar_rosca(fPal,rosca); //Genera la rosca con las 26 palabras.
	  dificultad(rosca,dat); //Oculta las letras de las palabras segun la dificultad elegida.
		if not(dat.salida) then begin //Si no se precioso "Volver al menu" entrara al juego.
			inicializar_datosJuego(dat); //Inicializa los datos temporales del juego.
			juego_rosca(rosca,dat); //Juego.
			impr_final(dat);
			readkey;
			impr_todasPalabras(rosca);
			readkey;
			if not(dat.salida) then
				guardar_puntaje(fPunt,dat); //Almacena el puntaje del jugador si completo las 2 rondas.
		end;
      liberar_rosca(rosca);
	end;
end;


{******************************************************************************************}
{********** Implementación de Acciones y Funciones Auxiliares locales al módulo ***********}
{******************************************************************************************}

{Libera todos los nodos de la LSE de la rosca }
procedure liberar_rosca(var r:TRosca);
var
	pAux: TPuntero;
    i:integer;
begin
  i:=1;
  while i<=26 do begin //recorre el arreglo de la rosca eliminando los nodos de la LSE
	while (r[i].palabra.pri<>nil) do begin
		pAux := r[i].palabra.pri;
	    r[i].palabra.pri := (r[i].palabra.pri^).next;
		dispose(pAux);
	end;
    i:=i+1;
  end;
end;

{Inicializa los contadores de datos de la partida actual}
procedure inicializar_datosJuego(var d: TDatosJuego);
begin
	d.pasPal_rest := 3;
	d.pasPal_usd := 0;
	d.i := 1;
	d.ronda := 1;
	d.salida := false;
	d.punt_act := 0;
	d.correctas := 0;
	d.incorrectas := 0;
end;

{Funcion que dada una palabra te devuelve la misma cargada en una lista simplemente encadenada de caracteres}
function CargarPalabraEnLista(palStr: TPalabra ): TLista;
var
	palAux:TLista;
	c: TInfo;
	j: integer;
begin
	Inicializar(palAux);
	j:=0;
	while(j<Length((palStr.palabra))) do begin //Se recorre la palabra hasta su ultimo caracter
		j:=j+1;
		c.caracter:=upcase(palStr.palabra[j]); //Se asigna al campo caracter del TInfo el caracter de la palabra en la posicion j
		c.visible:=true;
		InsertarAlFinal(c,palAux);
	end;
	CargarPalabraEnLista:=palAux;
end;

{Genera la rosca con las 26 letras y sus respectivas palabras. Cada letra se le asigna aleatoriamente 1 palabra de las 5 dispobibles para dicha letra}
{PRE-CONDICION: El archivo "palabras.dat" debe contener exactamente 130 palabras}
procedure generar_rosca(var f: TfilePalabra;var rosca: TRosca);
var
	i,sigLetra,pos:integer;
	palAux:TPalabra;
begin
	randomize;
	reset(f);
	i:=1;
	sigLetra:=0;
	pos:=0;
	while i<= 26 do begin
		pos:=random(5)+sigLetra;//Devuelve alguna posicion de las 5 palabras de la letra actual.
		seek(f,pos);
		read(f,palAux);
		rosca[i].letra := upcase(palAux.letra);
		rosca[i].palabra := CargarPalabraEnLista(palAux);
		rosca[i].jugar := true;//Incializa todas las palabras en "true".
		rosca[i].color := 0;
		i:=i+1;
		sigLetra:=sigLetra+5;//Devuelve posicion a la siguiente letra.
	end;
	close(f);
end;

{Modifica las palabras en la rosca, tapando cierta cantidad de letras por palabra segun la dificultad elegida}
procedure generar_palabrasRosca(var rosca: TRosca; dif: integer);
var
	cant,i,j,pos: integer;
	letra: char;
begin
	randomize;
	j:=1;
	while j<=26 do begin;
		cant := rosca[j].palabra.cant; //Longitud de la palabra.
		letra := rosca[j].letra; //Letra a la que pertenece la palabra.
		i:=1;
		while (i<=dif) and (i<= cant div 2 ) do begin // ciclo que se repite dependiendo de la cantidad de letras de la palabra y la dificultad
			repeat
				pos:=random(cant)+1;//Genera un numero aleatorio entre 1 y la cantidad de letras de la palabra para usarlo como posicion
			until (Not(CheckEnPosCaracter(rosca[j].palabra,pos,letra))and(CheckEnPosVisible(rosca[j].palabra,pos)));//hasta que no se encuentre la letra a la que pertenece la palabra,o ya este oculta
			ocultar_letra(rosca[j].palabra,pos);//Oculta un caracter segun la posicion
			i:=i+1;
		end;
		j:=j+1;
	end;
end;

{Menu que genera la dificultad en la rosca}
procedure dificultad(var rosca: TRosca; var dat: TDatosJuego);
begin
	impr_dificultad(dat);
	case dat.dif of
		FACIL : generar_palabrasRosca(rosca,2);
		DIFICIL : generar_palabrasRosca(rosca,10);
	end;
end;

{Modulo que retorna "true" si la respuesta del usuario coincide con la palabra}
function comprobar_palabra(resp: string; pal: TLista): boolean;
var
	igual: boolean;
	i: integer;
begin
	igual := true;//Asume que las palabras son iguales hasta encontrar una diferencia.
	i:=1;
	if(pal.cant = length(resp))then begin //Verifica la longitud de las dos palabras
		while((igual) and (i<=length(resp)))do begin
			if (obtener_letra(pal,i) <> resp[i]) then
				igual := false;
			i := i+1;
		end;
	end
	else
		igual := false;//Si son distintas longitudes, no es la misma palabra.
	comprobar_palabra:=igual;
end;

{Modulo que ejecuta la opcion "Jugar Palabra"}
procedure jugar_palabra(var rosca: TRosca; var dat: TDatosJuego);
var
	respuesta: string;
	result : boolean;
begin
	gotoxy(25,19);
	write(' > ');
	readln(respuesta);
	result := comprobar_palabra(upcase(respuesta),rosca[dat.i].palabra);
	if (result) then begin
		gotoxy(8,16);
		textcolor(texto_select);
		textbackground(green);
		write('           [ PALABRA CORRECTA ]           ');
		textbackground(texto_fondoUnSelect);
		dat.correctas := dat.correctas + 1;
		rosca[dat.i].color := 1;
		case dat.ronda of
			1: dat.punt_act := dat.punt_act + 2;//En la primera vuelta suma 2 puntos
			2: dat.punt_act := dat.punt_act + 1;//En la segunda vuelta suma 1 punto
		end;
	end
	else begin
		dat.incorrectas := dat.incorrectas + 1;
		gotoxy(8,16);
		seleccion_error('          [ PALABRA INCORRECTA ]          ');
		rosca[dat.i].color := 2;
	end;
	dat.pasPal_rest := 3; //Vuelve el contador de PasaPalabras restantes a 3.
	rosca[dat.i].jugar:= false;//La palabra no vuelve a jugar en la 2da vuelta.
	readkey;
end;

{Modulo que ejecuta la opcion "PasaPalabra"}
procedure jugar_pasaPalabra(var rosca: TRosca; var dat: TDatosJuego);
begin
	if (dat.ronda=1) then begin
		if (dat.pasPal_rest > 0) then begin
			dat.pasPal_rest := dat.pasPal_rest - 1; //PasaPalabra restantes disminuye en 1.
			dat.pasPal_usd := dat.pasPal_usd + 1; //PasaPalabra usadas aumenta en 1.
			rosca[dat.i].color := 3;
		end
		else begin
			gotoxy(8,16);
			seleccion_error('No le quedan PasaPalabras debe jugar');
			jugar_palabra(rosca,dat);
		end;
	end
	else begin
		gotoxy(8,16);
		seleccion_error('No puede pasar palabra en la segunda ronda');
		jugar_palabra(rosca,dat);
	end;
end;

{Juego principal}
procedure juego_rosca(var rosca: TRosca; var dat: TDatosJuego);
var
	menu: integer;
begin
	inicializar_datosJuego(dat);
	while ((dat.ronda<=2) and not(dat.salida)) do begin
		dat.i := 1;
		while ((dat.i<=26) and not(dat.salida)) do begin
			clrscr;
			impr_bordes();
			impr_abcedario(rosca);
			if (rosca[dat.i].jugar) then begin//Si la palabra juega muestra las opciones, sino pasa a la siguente
				impr_palabra(rosca,dat.i);
				impr_datos(dat);//Muestra los datos en pantalla.
				impr_menuJuego(menu);
				case menu of
					1: jugar_palabra(rosca,dat);
					2: jugar_pasaPalabra(rosca,dat);
					3: dat.salida:= true;
				end;
			end;
			dat.i:=dat.i+1;
		end;
		dat.ronda:= dat.ronda+1;
	end;
end;

end.
