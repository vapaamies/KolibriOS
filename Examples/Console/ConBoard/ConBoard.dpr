program ConBoard;

uses
  CRT, KolibriOS;

var
  LogFilePath: PKolibriChar = '/tmp0/1/BOARDLOG.TXT';

  Ch: KolibriChar;
  Prefix: array[0..3] of KolibriChar; // #0#0#0#0 by program start
  PrefixIndex: LongWord = 0; // 0 by program start but warning
  IsStartLine: Boolean = True;
  Attr: TFileAttributes;
  BytesWritten: LongWord;

begin
  InitConsole('Console board');

  if CmdLine^ <> #0 then
    LogFilePath := CmdLine;

  repeat
    if DebugRead(Ch) then
    begin
      if IsStartLine then
      begin
        Prefix[PrefixIndex] := Ch;
        if PrefixIndex = High(Prefix) - 1 then
        begin
          // Kernel
          if (Prefix[0] = 'K') and (Prefix[1] = ' ') and (Prefix[2] = ':') then
            TextColor(Yellow)
          else
            // Launcher
            if (Prefix[0] = 'L') and (Prefix[1] = ':') and (Prefix[2] = ' ') then
              TextColor(White)
            else
              TextColor(LightGray);
          IsStartLine := False;
          PrefixIndex := Low(Prefix);
          with GetSystemTime do
            con_printf('[%02x:%02x:%02x] ', Hours, Minutes, Seconds);
          con_write_asciiz(Prefix);
          LongWord(Prefix) := 0; // Prefix := #0#0#0#0;
        end
        else
          Inc(PrefixIndex);
      end
      else
      begin
        con_write_string(@Ch, 1);
        if Ch = #10 then
        begin
          IsStartLine := True;
          TextColor(LightGray);
        end;
      end;

      if GetFileAttributes(LogFilePath, Attr) = ERROR_FILE_NOT_FOUND then
      begin
        CreateFile(LogFilePath);
        Attr.Size := 0;
      end;
      WriteFile(LogFilePath, Ch, SizeOf(Ch), Attr.Size, BytesWritten);
    end;
  until LongBool(con_get_flags and CON_WINDOW_CLOSED);
end.
