program SwapMouseButtons;

uses
  Forms,
  SMB in 'SMB.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SwapMouseButtons';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
