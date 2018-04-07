// Materia: Introduccion a la Algoritmica y Programacion 2016
// Proyecto fin de año "Juego PasaPalabra".
// Comisión n°2 - Grupo n°7
// Integrantes:
// - Elena, Pablo.
// - Gremiger, Santiago.
// - Martinez, Christian.
// **********************

// Unit dedicada al manejo de la interfaz del juego.

unit unitInterfaz;

interface
uses
	unitLista,unitTipos,crt;

{======================================================================================}
{Declaraciones de las acciones y funciones visibles para quienes utilizan esta unidad}

{Imprime el logo del juego}
procedure logo();

{Crea los bordes de la pantalla: anch: 89 x alt: 31}
procedure impr_bordes();

{Imprime la pantalla de inicio de usuario}
procedure impr_pantallaInicial(var opc: integer);

{Imprime la pantalla lara el login de usuario}
procedure impr_login(var usuario: TListaUsuarios);

{Imprime la pantalla para la creacion de un nuevo usuario}
procedure impr_nuevoUsuario(var usuario: TListaUsuarios);

{Imprime la pantalla del usuario inexistente}
procedure impr_usuarioExistente();

{Imprime la pantalla para el usuario inexistente}
procedure impr_usuarioInexistente(var opc: integer; menuInicial: boolean);

{Imprime la pantalla para selecionar la dificultad}
procedure impr_dificultad(var dat: TDatosJuego);

{Imprime por pantalla la rosca}
procedure impr_abcedario(rosca: TRosca);

{Imprime por pantalla la palabra actual de la rosca con su respectiva letra}
procedure impr_palabra(rosca: TRosca; i: integer);

{Imprime por pantalla los datos actuales de la partida}
procedure impr_datos(dat: TDatosJuego);

{Imprime el menu para jugar durante la partida}
procedure impr_menuJuego(var opc: integer);

{Imprime una pantalla al finalizar el juego, con todos los datos}
procedure impr_final(dat: TDatosJuego);

{Imprime una pantalla al finalizar el juego mostrando todas las palabras completas}
procedure impr_todasPalabras(rosca: TRosca);

{Imprime la pantalla que muestra el promedio del usuario actual}
procedure impr_promedio(user: TListaUsuarios; prom: integer);

{Resalta un mensaje de error}
procedure seleccion_error(msj: string);

{Resalta la opcion en la que se esta posicionado}
procedure seleccion(msj: string);

{Desplaza el cursor del menu segun la tecla presionada}
procedure desplazar_selec(var y : integer; tecla: char; menu: integer);

{======================================================================================}
{Implementación del Módulo}
implementation

{******************************************************************************************}
{************************ Implementación de Acciones y Funciones Exportadas ***************}
{******************************************************************************************}

{Imprime el logo del juego}
procedure logo();
var
	x,y: integer;
begin
	x:=8;
	y:=4;
	textcolor(color_logo);
	gotoxy(x,y);
	write(' ___     _     ___     _     ___     _     _        _     ___   ___     _   ');
	gotoxy(x,y+1);
	write('| _ \   /_\   / __|   /_\   | _ \   /_\   | |      /_\   | _ ) | _ \   /_\  ');
	gotoxy(x,y+2);
	write('|  _/  / _ \  \__ \  / _ \  |  _/  / _ \  | |__   / _ \  | _ \ |   /  / _ \ ');
	gotoxy(x,y+3);
	write('|_|   /_/ \_\ |___/ /_/ \_\ |_|   /_/ \_\ |____| /_/ \_\ |___/ |_|_\ /_/ \_\');
	gotoxy(x,y+5);
	textcolor(texto_titulo);
	write('= = = = = = = = = = = = = = = = = EL JUEGO = = = = = = = = = = = = = = = = =');
	textcolor(texto_base);
end;

{Crea los bordes de la pantalla: anch: 89 x alt: 31}
procedure impr_bordes();
var
	x,y,i: integer;
begin
	clrscr;
	x:=1;
	y:=1;
	textcolor(borde);
	gotoxy(x,y);
	write('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *');
	i := y;
	repeat
		i := i + 1;
		gotoxy(x,i);
		write('*                                                                                       *');
	until (i = 30);
	gotoxy(x,y+30);
	write('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *');
	textcolor(texto_select);
end;

{Imprime la pantalla de inicio de usuario}
procedure impr_pantallaInicial(var opc: integer);
var
	x,y: integer;
	tecPress: char;
begin
	x:= 35;
	y:= 19;
	repeat
		impr_bordes();
		logo();
		gotoxy(x,17);
		textcolor(texto_titulo);
		write('    Bienvenido! ');
		textcolor(texto_base);
		gotoxy(x,19);
		writeln('- Ingresar usuario ');
		gotoxy(x,21);
		writeln('- Crear un nuevo usuario ');
		gotoxy(x,23);
		writeln('- Salir del juego ');
		gotoxy(x,y);
		case y of
			19:seleccion('- Ingresar usuario ');
			21:seleccion('- Crear un nuevo usuario ');
			23:seleccion('- Salir del juego ');
		end;
		tecPress := readkey;
		desplazar_selec(y,tecPress,2);//Si se presiono una tecla direccional se deplazara.
		if (tecPress = #13) then //Se preciono Enter en alguna opcion.
			case y of
                19: opc := 1;
				21:	opc := 2;
				23:	begin
						clrscr;
						halt;
					end;
			end;
	until (tecPress = #13);
end;

{Imprime la pantalla lara el login de usuario}
procedure impr_login(var usuario: TListaUsuarios);
var
	x,y: integer;
begin
	impr_bordes();
	logo();
	textcolor(borde);
	x:=20;
	y:=17;
	gotoxy(x,y);
	write('*************************************************');
	gotoxy(x,y+1);
	write('*                                               *');
	gotoxy(x,y+2);
	write('*                                               *');
	gotoxy(x,y+3);
	write('*                                               *');
	gotoxy(x,y+4);
	write('*************************************************');
	gotoxy(x+3,y+2);
	textcolor(texto_titulo2);
	write('INGRESE USUARIO :');
	gotoxy(x+21,y+2);
	textcolor(texto_base);
	readln(usuario);
end;

{Imprime la pantalla para la creacion de un nuevo usuario}
procedure impr_nuevoUsuario(var usuario: TListaUsuarios);
var
	x,y: integer;
begin
	impr_bordes();
	logo();
	textcolor(borde);
	x:=20;
	y:=17;
	gotoxy(x,y);
	write('*************************************************');
	gotoxy(x,y+1);
	write('*                                               *');
	gotoxy(x,y+2);
	write('*                                               *');
	gotoxy(x,y+3);
	write('*                                               *');
	gotoxy(x,y+4);
	write('*************************************************');
	gotoxy(x+3,y+2);
	textcolor(texto_titulo2);
	write('NUEVO USUARIO :');
	gotoxy(x+19,y+2);
	textcolor(texto_base);
	readln(usuario);
end;

{Imprime la pantalla del usuario inexistente}
procedure impr_usuarioExistente();
begin
	impr_bordes();
	gotoxy(20,17);
	seleccion_error(' El usuario ya existe, por favor ingrese otro nombre ');
end;

{Imprime la pantalla para el usuario inexistente}
procedure impr_usuarioInexistente(var opc: integer; menuInicial: boolean); //menuInicial, indica si se encuentra en la pantalla de inico.
var
	x,y: integer;
	tecPress: char;
begin
	x:= 35;
	y:= 19;
	repeat
		impr_bordes();
		logo();
		gotoxy(x,17);
		seleccion_error('¡USUARIO INEXISTENTE!');
		textcolor(texto_base);//blanco
		gotoxy(x,19);
		writeln('- Ingresar usuario ');
		gotoxy(x,21);
		writeln('- Crear un nuevo usuario ');
		gotoxy(x,23);
		if (menuInicial) then
			writeln('- Salir del juego ') //Se encuentra en la pantalla de inicio.
		else
			writeln('- Volver al menu principal '); //Se encuentra dentro del menu principal
		gotoxy(x,y);
		case y of
			19:seleccion('- Ingresar usuario ');
			21:seleccion('- Crear un nuevo usuario ');
			23: begin
					if (menuInicial) then
						seleccion('- Salir del juego ')//Se encuentra en la pantalla de inicio.
					else
						seleccion('- Volver al menu principal ');//Se encuentra dentro del menu principal
				end;
		end;
		tecPress := readkey;
		desplazar_selec(y,tecPress,2);//Si se presiono una tecla direccional se deplazara.
		if (tecPress = #13) then //Se preciono Enter en alguna opcion.
			case y of
                19: opc:= 0; //No hace nada.
				21:	opc:= 1; //Crea un nuevo usuario.
				23:	begin
						if menuInicial then begin
							clrscr;
							halt;
						end
						else begin
							opc := 2;
						end;
					end;
			end;
	until (tecPress = #13);
end;

{Imprime la pantalla para selecionar la dificultad}
procedure impr_dificultad(var dat: TDatosJuego);
var
	x,y: integer;
	tecPress: char;
begin
	x:= 35;
	y:= 19;
	dat.salida := false;
	repeat
		impr_bordes();
		logo();
		textcolor(texto_titulo);//blanco
		gotoxy(x,17);
		writeln('=== DIFICULTAD ===');
		textcolor(texto_base);//blanco
		gotoxy(x,19);
		writeln('- Facil ');
		gotoxy(x,21);
		writeln('- Dificil ');
		gotoxy(x,23);
		writeln('- Volver al menu principal ');
		gotoxy(x,y);
		case y of
			19:seleccion('- Facil ');
			21:seleccion('- Dificil ');
			23:seleccion('- Volver al menu principal ');
		end;
		tecPress := readkey;
		desplazar_selec(y,tecPress,2);//Si se presiono una tecla direccional se deplazara.
		if (tecPress = #13) then //Se preciono Enter en alguna opcion.
			case y of
				19: dat.dif := FACIL;
				21:	dat.dif := DIFICIL;
				23:	dat.salida := true;
			end;
	until (tecPress = #13);
end;

{Imprime por pantalla la rosca}
procedure impr_abcedario(rosca: TRosca);
var
	x,y,i: integer;
begin
	x:=4;
	y:=5;
  	for i := 1 to 26 do begin
		x:= x+3;
		gotoxy(x,y);
		case rosca[i].color of
			0: textcolor(texto_base);
			1: textcolor(texto_correcto);
			2: textcolor(texto_incorrecto);
			3: textcolor(texto_pasa);
		end;
		write('[',rosca[i].letra,']')
	end;
end;

{Imprime por pantalla la palabra actual de la rosca con su respectiva letra}
procedure impr_palabra(rosca: TRosca; i: integer);
var
	x,y: integer;
begin
	x := 8;
	y := 12;
	gotoxy(x,y);
	textcolor(texto_titulo);
	write(' ',rosca[i].letra,':');
	gotoxy(x+4,y);
	textcolor(texto_titulo2);
	MostrarLista(rosca[i].palabra,false);
end;

{Imprime por pantalla los datos actuales de la partida}
procedure impr_datos(dat: TDatosJuego);
var
	x,y: Integer;
begin
	x := 55;
	y := 12;
	gotoxy(x,y);
	textcolor(texto_titulo);
	write('Usuario: ');
	textcolor(texto_base);
	write(dat.user);
	gotoxy(x,y+2);
	textcolor(texto_titulo);
	write('Puntaje: ');
	textcolor(texto_base);
	write(dat.punt_act);
	gotoxy(x,y+4);
	textcolor(texto_titulo);
	write('PasaPalabra restantes: ');
	textcolor(texto_base);
	write(dat.pasPal_rest);
	gotoxy(x,y+6);
	textcolor(texto_titulo);
	write('PasaPalabra usadas: ');
	textcolor(texto_base);
	write(dat.pasPal_usd);
	gotoxy(x,y+8);
	textcolor(texto_titulo);
	write('Palabras Correctas: ');
	textcolor(texto_base);
	write(dat.correctas);
	gotoxy(x,y+10);
	textcolor(texto_titulo);
	write('Palabras Incorrectas: ');
	textcolor(texto_base);
	write(dat.incorrectas);
	gotoxy(x,y+12);
	textcolor(texto_titulo);
	write('Dificultad: ');
	textcolor(texto_base);
    case dat.dif of //Segun el tipo, escribe la dificultad
		facil: write('Facil');
		dificil: write('Dificil');
    end;
    gotoxy(x,y+14);
	textcolor(texto_titulo);
	write('Vuelta: ');
	textcolor(texto_base);
	write(dat.ronda);
end;

{Imprime el menu para jugar durante la partida}
procedure impr_menuJuego(var opc: integer);
var
	x,y: integer;
	tecPress: char;
begin
	x:= 8;
	y:= 19;
	repeat
		textcolor(texto_base);
		gotoxy(x,19);
		writeln('- Jugar Palabra ');
		gotoxy(x,21);
		writeln('- PasaPalabra ');
		gotoxy(x,23);
		writeln('- Volver al menu principal ');
		gotoxy(x,y);
		case y of
			19:seleccion('- Jugar Palabra ');
			21:seleccion('- PasaPalabra ');
			23:seleccion('- Volver al menu principal ');
		end;
		tecPress := readkey;
		desplazar_selec(y,tecPress,2);//Si se presiono una tecla direccional se deplazara.
		if (tecPress = #13) then //Se preciono Enter en alguna opcion.
			case y of
				19: opc := 1;
				21: opc := 2;
				23: opc := 3;
			end;
	until (tecPress = #13);
end;

{Imprime una pantalla al finalizar el juego, con todos los datos}
procedure impr_final(dat: TDatosJuego);
var
	x,y: integer;
begin
	impr_bordes();
	logo();
	x:= 35;
	y:= 17;
	gotoxy(x-2,y-2);
	seleccion_error(' === JUEGO FINALIZADO === ');
	gotoxy(x,y);
	textcolor(texto_titulo);
	write('Usuario: ');
	textcolor(texto_base);
	write(dat.user);
	gotoxy(x,y+2);
	textcolor(texto_titulo);
	write('Puntaje: ');
	textcolor(texto_base);
	write(dat.punt_act);
	gotoxy(x,y+4);
	textcolor(texto_titulo);
	write('PasaPalabra usadas: ');
	textcolor(texto_base);
	write(dat.pasPal_usd);
	gotoxy(x,y+6);
	textcolor(texto_titulo);
	write('Palabras Correctas: ');
	textcolor(texto_base);
	write(dat.correctas);
	gotoxy(x,y+8);
	textcolor(texto_titulo);
	write('Palabras Incorrectas: ');
	textcolor(texto_base);
	write(dat.incorrectas);
	gotoxy(x,y+10);
	textcolor(texto_titulo);
	write('Dificultad: ');
	textcolor(texto_base);
    case dat.dif of //Segun el tipo, escribe la dificultad
		facil: write('Facil');
		dificil: write('Dificil');
    end;
end;

{Imprime una pantalla al finalizar el juego mostrando todas las palabras completas}
procedure impr_todasPalabras(rosca: TRosca);
var
	x,y,i: integer;
begin
	x := 9;
	y := 3;
	impr_bordes();
	gotoxy(x+20,y);
	textcolor(texto_titulo);
	write('=== PALABRAS COMPLETAS ===');
	//Imprime la primer columna con la mitad de las palabras.
	for i := 1 to 13 do begin
		y := y + 2;
		gotoxy(x,y);
		textcolor(texto_base);
		write(rosca[i].letra,': ');
		case rosca[i].color of
			0: textcolor(texto_base);
			1: textcolor(texto_correcto);
			2: textcolor(texto_incorrecto);
			3: textcolor(texto_pasa);
		end;
		MostrarLista(rosca[i].palabra,true);
	end;
	//Imprime la segunda columna con la mitad de las palabras.
	y := 3;
	for i := 14 to 26 do begin
		y := y + 2;
		gotoxy(x+40,y);
		textcolor(texto_base);
		write(rosca[i].letra,': ');
		case rosca[i].color of
			0: textcolor(texto_base);
			1: textcolor(texto_correcto);
			2: textcolor(texto_incorrecto);
			3: textcolor(texto_pasa);
		end;
		MostrarLista(rosca[i].palabra,true);
	end;
end;

{Imprime la pantalla que muestra el promedio del usuario actual}
procedure impr_promedio(user: TListaUsuarios; prom: integer);
var
	x,y: integer;
begin
	clrscr;
	impr_bordes();
	logo();
	textcolor(green);
	x:=20;
	y:=17;
	gotoxy(x,y);
	write('*************************************************');
	gotoxy(x,y+1);
	write('*                                               *');
	gotoxy(x,y+2);
	write('*                                               *');
	gotoxy(x,y+3);
	write('*                                               *');
	gotoxy(x,y+4);
	write('*************************************************');
	gotoxy(x+3,y+2);
	if(prom<0)then begin
		write('No existen puntajes cargados para ',user);
	end
	else begin
		textcolor(texto_titulo);
		write('Promedio de ',user,': ');
		textcolor(texto_titulo2);
		write(prom);
	end;
end;

{Resalta un mensaje de error}
procedure seleccion_error(msj: string);
begin
	textcolor(texto_select);//negro
	TextBackground(4);//blanco
	write(msj);
	textcolor(texto_unSelect);//blanco
	TextBackground(texto_fondoUnSelect);//negro
end;

{Resalta la opcion en la que se esta posicionado}
procedure seleccion(msj: string);
begin
	textcolor(texto_select);//negro
	TextBackground(blue);//blanco
	write(msj);
	textcolor(texto_unSelect);//blanco
	TextBackground(texto_fondoUnSelect);//negro
end;

{Desplaza el cursor del menu segun la tecla presionada}
procedure desplazar_selec(var y : integer; tecla: char; menu: integer);
begin
	//Presiono Tecla Arriba.
	if (tecla = #72) then begin
		if (menu = 1) then//Desplaza en el menu de juego.
			case y of
				17: y := 27;
				19: y := 17;
				21: y := 19;
				23: y := 21;
				25: y := 23;
				27: y := 25;
			end;
		if (menu = 2) then//Desplaza en el menu de juego.
			case y of
				19: y := 23;
				21: y := 19;
				23: y := 21;

			end;
	end;
	//Presiono Tecla Abajo.
	if (tecla = #80) then begin
		if (menu = 1) then//Desplaza en el menu de juego.
			case y of
				17: y := 19;
				19: y := 21;
				21: y := 23;
				23: y := 25;
				25: y := 27;
				27: y := 17;
			end;
		if (menu = 2) then//Desplaza en el menu de juego.
			case y of
				19: y := 21;
				21: y := 23;
				23: y := 19;
			end;
	end;
end;

end.
