// Materia: Introduccion a la Algoritmica y Programacion 2016
// Proyecto fin de año "Juego PasaPalabra".
// Comisión n°2 - Grupo n°7
// Integrantes:
// - Elena, Pablo.
// - Gremiger, Santiago.
// - Martinez, Christian.
// **********************

// Unit dedicada exclusivamente a la declaracion de todos los nuevos tipos.

unit unitTipos;

interface

const
	color_logo = 13;//Magenta claro
	borde = 11;//Cyan claro
	texto_select = 0; //Negro
	texto_fondoSelect = 15; //Fondo blanco
	texto_unSelect = 15;//Blanco
	texto_fondoUnSelect = 0;//Fondo Negro
	texto_base = 7;//Gris Claro
	texto_titulo = 9;//Azul Claro
	texto_titulo2 = 15;//Blanco
	texto_correcto = 10;//Verde Claro
	texto_incorrecto = 4;//Rojo
	texto_pasa = 14;//Amarillo
type

	//Tipo para la dificultad del del juego.
	TDificultad = (FACIL,DIFICIL);

	TPalabra=record
		palabra:string[20];//Lista de caracteres(lse) debe ser
		letra:char;
	end;

	{***************************************************************}
	{**************************** LISTAS ***************************}
	{***************************************************************}

	//Tipo de la informacion que va a contener la lista.
	TInfo= record
		caracter: char;
		visible: boolean; {Ver el caracter. "True" para visible, "False" para oculto}
	end;

	TPuntero = ^TNodo; //Puntero a un nodo de la lista.

	//Representa un nodo de la lista.
	TNodo = record
		info: TInfo;
		next: TPuntero; //Puntero al nodo siguiente.
	end;

	TLista = record
		pri: TPuntero; //Puntero al primer nodo de la lista.
		ult: TPuntero; //Puntero al ultimo nodo de la lista.
		cant : integer; //Contiene la cantidad de nodos que tiene la lista.
	end;

	{***************************************************************}
	{**************************** ROSCA ****************************}
	{***************************************************************}

	//Campo para cada palabra del arreglo TRosca.
	TPalabraRosca = record
		letra: char; //Letra a la que pertenece la palabra.
		palabra: TLista; //Palabra almacenada en una LSE.
		jugar: boolean; //Ver la palabra. "True" para visible, "False" para oculto.
		color: integer;//Segun su valor mostrara un color en la rosca. [0:Neutro -1:Correcto -2:Incorrecto -3:PasaPalabra]
	end;

	//Arreglo de "TPalabraRosca". Contiene las 26 palabras.
	TRosca = array[1..26] of TPalabraRosca;

	TRegPalabras = record
		letra: char;
		palabra: TLista;
	end;


	{***************************************************************}
	{*************************** USUARIO ***************************}
	{***************************************************************}


	//Tipo al que pertenece el archivo "usuarios.dat"
	TListaUsuarios = string[30];

	{****************************************************************}
	{*************************** PUNTAJES ***************************}
	{****************************************************************}

	TPuntaje = record
		nombre : string; //Nombre del usuario.
		puntaje: integer; //Puntaje.
		dif: TDificultad; //Dificultad del puntaje obtenido.
	end;

	//LSE que contiene los usarios
	TPunt_TListaPuntajes = ^TListaPuntajes;
	TListaPuntajes = record
		usuario: TPuntaje;
		next: TPunt_TListaPuntajes;
	end;

	{***************************************************************}
	{*************************** ARCHIVO ***************************}
	{***************************************************************}

	TfileTexto = text; //Archivo "palabras.txt"
	TfilePuntajes = file of TPuntaje; //Archivo "puntaje.dat"
	TfileUsuarios = file of TListaUsuarios; //Archivo usuarios.dat
	TfilePalabra = file of TPalabra; //Archivo "palabras.dat"

	{****************************************************************}

	TDatosJuego = record
		user: TListaUsuarios; //Nombre del usuario actual;
		pasPal_rest: integer; // PasaPalabras restantes (1..3).
		pasPal_usd: integer; //PasaPalabras usadas en total.
		i: integer; //Indice de la rosca.
		ronda: integer; //N° de vuelta.
		salida: boolean; //Salida de la partida actual.
		punt_act: integer; //Puntaje actual.
		dif: TDificultad; //Dificultad de la partida actual
		correctas: integer; //Cantidad de palabras correctas.
		incorrectas: integer; //Cantidad de palabras incorrectas.
	end;





implementation
end.
