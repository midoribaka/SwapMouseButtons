unit SMB;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, {Local, global,}
  StdCtrls, ShellAPI, ExtCtrls, jpeg;


type
  TInitializeHook = procedure(HookHandle: HHook; NewLogdir:string); stdcall;

  TMainForm = class(TForm)
    Image: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageClick(Sender: TObject);
    public
      LibHandle: HModule;  {dll handle}
      HookProcAddress: pointer;  {memory address of hook procedure in windows}
      InitializeHook: TInitializeHook; {address of the initial call procedure}
      currenthook:integer;
    end;
var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{**************** FormCreate ***********}
procedure TMainForm.FormCreate(Sender: TObject);
begin
  currenthook:=-1;
  {To install a global keyboard hook,
   1. Load the DLL containing the hook procedure.
   2. Get the addresses of the initial procedure to be called to initialize
      the hook and the procedure to be called when a key is pressed.
   3. Call "SetWindowsHookEx" specifying "WH_KEYBOARD" as the hook type and the
      addresses obtained in step 2.  Set "threadid" to 0 to indicate a global hook.
   4. Call the hook initializatoion procedure.
  }
  {1}
   LibHandle:=LoadLibrary('SwapMB.dll');
   if LibHandle=0 then
   begin  {if loading fails, exit and return false}
     showmessage('Load for ''SwapMB.dll'' failed');
     halt;
   end;
   {2}
   HookProcAddress:=GetProcAddress(LibHandle, pchar(1) {or 'GlobalKeyBoardHook'});
   InitializeHook:=GetProcAddress(LibHandle,pchar(2) {or 'SetHookHandle'});
   if (HookProcAddress=nil)or(addr(InitializeHook)=nil) then
   begin  {if loading fails, unload library, exit and return false}
     showmessage('Hook procedure addresses could not be obtained, halted');
     halt;
   end;
   {3} CurrentHook:=SetWindowsHookEx(WH_KEYBOARD,HookProcAddress,LibHandle,0);
   {4} InitializeHook(CurrentHook, Extractfilepath(application.exename));
end;



{************ FormClose **********}
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnhookWindowshookEx(currenthook);
  If libhandle>0 then FreeLibrary(LibHandle);
end;


procedure TMainForm.ImageClick(Sender: TObject);
begin
Application.Terminate;
end;

end.
