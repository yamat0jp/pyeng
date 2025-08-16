unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PythonEngine, Vcl.PythonGUIInputOutput,
  Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    Memo2: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    Button1: TButton;
    PythonModule1: TPythonModule;
    PythonModule2: TPythonModule;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  PythonEngine1.ExecStrings(Memo1.Lines);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  rsl: PPyObject;
begin
  rsl:=PythonEngine1.EvalStrings(['from math import sqrt','result = sqrt(16)']);
  ShowMessage(PythonEngine1.PyObjectAsString(rsl));
end;

end.
