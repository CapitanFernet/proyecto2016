// Materia: Introduccion a la Algoritmica y Programacion 2016
// Proyecto fin de año "Juego PasaPalabra".
// Comisión n°2 - Grupo n°7
// Integrantes:
// - Elena, Pablo.
// - Gremiger, Santiago.
// - Martinez, Christian.
// **********************

// Unit dedicada al manejo del usuario.

unit unitUsuario;

interface
uses
	unitTipos,unitInterfaz,crt;

{======================================================================================}
{Declaraciones de las acciones y funciones visibles para quienes utilizan esta unidad}

{Inicializa el archivo "usuarios.dat" y lo prepara para su uso}
procedure inicializar_usuarios(var f: TfileUsuarios);

{Pantalla de inicio al ingresar al juego, permite ingresar usuario o crear uno nuevo}
procedure pantallaInicial(var f: TfileUsuarios; var usuario: TListaUsuarios);

{Pantalla para el login de un usuario, si el usuario no existe da la opcion de crearlo}
procedure login_usuario(var f: TfileUsuarios; var usuario: TListaUsuarios; menuInicial: boolean);

{Pantalla para la creacion de un nuevo usuario}
procedure crear_usuario(var f: TfileUsuarios; var user: TListaUsuarios);

{======================================================================================}
{Implementación del Módulo}
Implementation


{******************************************************************************************}
{********** Declaracion de Acciones y Funciones Auxiliares locales al módulo **************}
{******************************************************************************************}

{devuelve "true" si el usuario ya existe en el archivo, "false" si no existe}
function busq_usuario(var f: TfileUsuarios; usuario: TListaUsuarios): boolean; forward;

{Recibe usuario y lo almacena en el archivo "usuarios.dat"}
procedure guardar_usuario(var f: TfileUsuarios; usuario: TListaUsuarios); forward;


{******************************************************************************************}
{************************ Implementación de Acciones y Funciones Exportadas ***************}
{******************************************************************************************}

{Inicializa el archivo "usuarios.dat" y lo prepara para su uso}
procedure inicializar_usuarios(var f: TfileUsuarios);
begin
	assign(f,'usuarios.dat');
	{$I-}
	reset(f);
	{$I+}
	if IOResult<>0 then
		rewrite(f);
end;

{Pantalla de inicio al ingresar al juego, permite ingresar usuario o crear uno nuevo}
procedure pantallaInicial(var f: TfileUsuarios; var usuario: TListaUsuarios);
var
	opc: integer;
begin
	impr_pantallaInicial(opc);
	case opc of
		1: login_usuario(f,usuario,true);
		2: crear_usuario(f,usuario);
	end;
end;

{Pantalla para el login de un usuario, si el usuario no existe da la opcion de crearlo}
procedure login_usuario(var f: TfileUsuarios; var usuario: TListaUsuarios; menuInicial: boolean);
var
	opc: integer;
	userAux: TListaUsuarios;
begin
	clrscr;
	repeat
		impr_login(userAux);
		userAux:= upcase(userAux);
		if not(busq_usuario(f,userAux)) then begin //El usuario no existe.
			impr_usuarioInexistente(opc,menuInicial);
			case opc of
				1: crear_usuario(f,userAux); //Crea un nuevo usuario.
				2: userAux := usuario; //Seguira logueado con el usuario actual.
			end;
		end;
	until (busq_usuario(f,userAux)); //Si el usuario existe sale del ciclo.
	usuario := userAux;
end;

{Pantalla para la creacion de un nuevo usuario, y deja logeado este nuevo usario}
procedure crear_usuario(var f: TfileUsuarios; var user: TListaUsuarios);
var
	salida: boolean;
begin
	clrscr;
    salida:=false;
	repeat
		impr_nuevoUsuario(user);
		user:= upcase(user);
		if (busq_usuario(f,user)) then begin //El usuario existe, no se puede volver a crear.
			impr_usuarioExistente();
			readkey;
		end
		else begin
			if (user<>'') then begin //El usuario no debe ser vacio (Se presiono enter sin ingresar un nombre de usuario).
				guardar_usuario(f,user);
				salida:=true;
			end;
		end;
	until(salida=true);
end;

{******************************************************************************************}
{********** Implementación de Acciones y Funciones Auxiliares locales al módulo ***********}
{******************************************************************************************}

{devuelve "true" si el usuario ya existe en el archivo, "false" si no existe}
function busq_usuario(var f: TfileUsuarios; usuario: TListaUsuarios): boolean;
var
	userAux: TListaUsuarios;
	existe: boolean;
begin
	existe := false;
	reset(f);
	while (not(EOF(f)) and not(existe)) do begin
		read(f,userAux);
		if (usuario = userAux) then
			existe := true;
	end;
	busq_usuario := existe;
	close(f);
end;

{Recibe usuario y lo almacena en el archivo "usuarios.dat"}
procedure guardar_usuario(var f: TfileUsuarios; usuario: TListaUsuarios);
begin
	reset(f);
	usuario:= upcase(usuario);
	seek(f,filesize(f));
	write(f,usuario);
	close(f);
end;

end.
