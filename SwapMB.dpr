library SwapMB;

uses
  SysUtils,
  Controls,
  Classes,
  windows,
  messages,
  inifiles;

var CurrentHook: HHook;



{******* GlobalKeyboardHook **********}
function GlobalKeyBoardHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
{"Hook" procedure to be loaded from main .exe"}
var
  poweroption:integer;
begin
  if code<0 then
  begin
     {
     According to documentation if code is <0 your keyboard hook should always
     run CallNextHookEx and then return the value from it.}
    result:=CallNextHookEx(CurrentHook,code,wParam,lparam);
  end
  else
  begin
    { wParam contains the scan code of the key }
    if  (wparam=VK_SPACE) // key down
    then
    begin
    SystemParametersInfo(SPI_SETMOUSEBUTTONSWAP, 1, nil, 0);  // swap mouse buttons
     if (lparam and $80000000)<>0  // key up
    then
    SystemParametersInfo(SPI_SETMOUSEBUTTONSWAP, 0, nil, 0);  // cancel swap
      result:=1;  {stop the key from propagating further}
    end
    else
    begin {not our key, pass it on}
      result:=CallNextHookEx(CurrentHook,code,wParam,lparam); {call the next hook proc if there is one}
    end;
  end;
end;

procedure SetHookHandle(HookHandle: HHook; NewDir:string); stdcall;
begin
    CurrentHook:=HookHandle;
end;

exports GlobalKeyBoardHook index 1,
        SetHookHandle index 2;
begin


end.



