Program CrearArchReg;
Uses unitListaImplementada;
type
	TPalabra=record
            	palabra:TLista;//TLista de caracteres(lse) debe ser
				letra:char;
         		end;
  tarch=file of TPalabra;

var
archPal:Text;
letra:char;
mInfo:TInfo;
miTLista:TLista;
arch:tarch;
regDePal:TPalabra;
r:integer;
i:integer;
caracterInit:Char;
{Inicializa el archivo de registro}
procedure Init(var arch: tarch);
	begin
		assign (archPal,'palabras.txt');
		assign(arch,'palabras.dat');
		Inicializar(miTLista);	
		{$I-}
			reset(arch);
		{$I+}	
		if IOResult=0 then
				reset(arch)
		else
				rewrite(arch);
	end;

{Carga el archivo de registro a partir de un archivo que contiene palabras}
procedure CargarRegistro(var arch: tarch; var archPal:Text);
begin
	reset (archPal);
	i:=0;
	caracterInit:='a';
	while(not(EOF(archPal))) do
	begin
		while(not(EOLN(archPal))) do
		begin
			read(archPal,letra);
			mInfo.caracter:=letra;
			mInfo.visible:=true;
			InsertarAlFinal(mInfo,miTLista);
			regDePal.palabra:=miTLista;
		end;
		if(i<5) then //Son cinco palabras entonces a las primeras cinco les asigna la letra 'a'
			begin
				regDePal.letra:=caracterInit;
				write(arch,regDePal);
				i:=i+1;
			end
		else
			begin
				caracterInit:=Succ(caracterInit); //Agrega el siguiente del abecedario
				regDePal.letra:=caracterInit;
				write(arch,regDePal);
				i:=1;
			end;
		
		Inicializar(miTLista);
		readln(archPal);
	end;
close(archPal);
close(arch);
end;

{Muestra las palabras que estan cargadas en el archivo de registro}
Procedure MostrarPalabras(var arch: tarch);
begin	
	reset(arch);
	while(not(EOF(arch))) do
	begin
		read(arch,regDePal);
		MostrarLista(regDePal.palabra);
		writeln();
	end;
	close(arch);
end;
{Programa Principal}
begin
	Init(arch);
	CargarRegistro(arch,archPal);	
	MostrarPalabras(arch);
end.
	
