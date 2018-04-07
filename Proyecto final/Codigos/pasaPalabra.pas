// Materia: Introduccion a la Algoritmica y Programacion 2016
// Proyecto fin de año "Juego PasaPalabra".
// Comisión n°2 - Grupo n°7
// Integrantes:
// - Elena, Pablo.
// - Gremiger, Santiago.
// - Martinez, Christian.
// **********************

// Programa principal.

program pasaPalabra;
uses
	unitLista,unitTipos,unitUsuario,unitPuntaje,unitJuego,unitInterfaz,crt;

var
	f_puntaje: TfilePuntajes;
	f_usuario: TfileUsuarios;
	f_palabra: TfilePalabra;
	usuario: TListaUsuarios;

{Ejecuta la opcion del seleccionada en el menu principal}
procedure ejecutar_opcion(y: integer; var user: TListaUsuarios; var fPunt: TfilePuntajes;var fUser: TfileUsuarios;var fPal: TfilePalabra);
begin
	case y of
		17: iniciar_juego(user,fPunt,fUser,fPal);
		19: promedio_usuario(fPunt,user);
		21: login_usuario(fUser,user,false);
		23: crear_usuario(fUser,user);
		25: mejores_puntajes(fPunt);
	end;
end;

{Pantalla del menu principal}
procedure menu_principal(user: TListaUsuarios; var fPunt: TfilePuntajes;var fUser: TfileUsuarios;var fPal: TfilePalabra);
var
	x,y: integer;
	tecPress: char;
begin
	x:= 32;
	y:= 17;
	repeat
		clrscr;
		impr_bordes();
		logo();
		gotoxy(x,15);
		textcolor(texto_titulo);
		write('   Bienvenido ');
		textcolor(texto_base);
		write(user,'!');
		gotoxy(x,17);
		writeln('- Iniciar partida');
		gotoxy(x,19);
		writeln('- Ver mi promedio (Puntaje)');
		gotoxy(x,21);
		writeln('- Cambiar de usuario');
		gotoxy(x,23);
		writeln('- Crear usuario');
		gotoxy(x,25);
		writeln('- Ver los 10 mejores puntajes');
		gotoxy(x,27);
		writeln('- Salir del juego');
		//Resalta la opcion en la que se encuentra.
		gotoxy(x,y);
		case y of
			17:seleccion('- Iniciar partida');
			19:seleccion('- Ver mi promedio (Puntaje)');
			21:seleccion('- Cambiar de usuario');
			23:seleccion('- Crear usuario');
			25:seleccion('- Ver los 10 mejores puntajes');
			27:seleccion('- Salir del juego');
		end;
		tecPress := readkey;
		desplazar_selec(y,tecPress,1);//Si se presiono una tecla direccional se deplazara.
		if (tecPress = #13) then //Se preciono Enter en alguna opcion.
			ejecutar_opcion(y,user,fPunt,fUser,fPal);
	until ((tecPress = #13) and (y=27));
	clrscr;
end;

{Programa Principal}
begin
	inicalizar_puntajes(f_puntaje);
	inicializar_usuarios(f_usuario);
	pantallaInicial(f_usuario,usuario);
	menu_principal(usuario,f_puntaje,f_usuario,f_palabra);
end.

