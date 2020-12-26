program GetCurrentDir;

uses
  KolibriOS, CRT;

const  
  BUFFER_SIZE = 256;

var
  Buffer: array[0..BUFFER_SIZE - 1] of KolibriChar;

begin
  InitConsole('Get Current Directory');

  GetCurrentDirectory(Buffer, BUFFER_SIZE);

  con_printf('Application Path is "%s"'#10, AppPath);
  con_printf('Command Line is "%s"'#10, CmdLine);
  con_printf('Current Directory is "%s"'#10, Buffer);
end.
