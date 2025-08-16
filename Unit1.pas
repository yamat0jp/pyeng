unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, PythonEngine,
  Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.ExtDlgs, Vcl.PythonGUIInputOutput;

type
  TDetectionResult = record
    BBox: array [0 .. 3] of Double; // x1, y1, x2, y2
    Confidence: Double;
    ClassID: Integer;
    ClassName: string;
  end;

  TYOLODetector = class
  private
    FPythonPath: string;
    FScriptPath: string;
    FModelPath: string;
  public
    constructor Create;
    function DetectObjects(const Output: string): TArray<TDetectionResult>;
    property PythonPath: string read FPythonPath write FPythonPath;
    property ScriptPath: string read FScriptPath write FScriptPath;
    property ModelPath: string read FModelPath write FModelPath;
  end;

  TForm1 = class(TForm)
    btnDetect: TButton;
    TrackBar1: TTrackBar;
    lblConfidence: TLabel;
    Memo2: TMemo;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Button1: TButton;
    PythonEngine1: TPythonEngine;
    Memo1: TMemo;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    PythonDelphiVar1: TPythonDelphiVar;
    Memo3: TMemo;
    PythonDelphiVar2: TPythonDelphiVar;
    Edit1: TEdit;
    PythonDelphiVar3: TPythonDelphiVar;
    Label1: TLabel;
    procedure btnDetectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    FYOLODetector: TYOLODetector;
    procedure DrawDetections(const Detections: TArray<TDetectionResult>);
    procedure LogMessage(const Msg: string);
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;

implementation

uses JSON, Jpeg, System.Generics.Collections, System.StrUtils;

{$R *.dfm}

procedure TForm1.btnDetectClick(Sender: TObject);
var
  Detections: TArray<TDetectionResult>;
begin
  if Image1.Picture.Graphic.Empty then
  begin
    ShowMessage('まず画像を選択してください');
    Exit;
  end;

  PythonDelphiVar3.Value:=Edit1.Text;

  btnDetect.Enabled := False;
  try
    LogMessage('YOLO検出を開始...');

    PythonDelphiVar1.Value := OpenPictureDialog1.FileName;
    Memo3.Lines.Clear;
    PythonEngine1.ExecStrings(Memo1.Lines);
    for var i := 1 to 3 do
      Memo3.Lines.Delete(0);
    Detections := FYOLODetector.DetectObjects(Memo3.Text);

    LogMessage(Format('%d個のオブジェクトを検出しました', [Length(Detections)]));

    for var i := 0 to High(Detections) do
      LogMessage(Format('[%d] %s (信頼度: %.2f%%) - 座標: (%.0f, %.0f, %.0f, %.0f)',
        [i + 1, Detections[i].ClassName, Detections[i].Confidence * 100,
        Detections[i].BBox[0], Detections[i].BBox[1], Detections[i].BBox[2],
        Detections[i].BBox[3]]));

    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    // 検出結果を画像に描画
    DrawDetections(Detections);

  except
    on E: Exception do
    begin
      LogMessage('エラー: ' + E.Message);
      ShowMessage('検出中にエラーが発生しました: ' + E.Message);
    end;
  end;

  btnDetect.Enabled := True;
end;

{ TYOLODetector }

constructor TYOLODetector.Create;
begin
  inherited;
  FPythonPath := 'python'; // Pythonのパス
  FScriptPath := 'yolo_detector.py'; // スクリプトのパス
  FModelPath := 'yolo11n.pt'; // YOLOモデルのパス
end;

function TYOLODetector.DetectObjects(const Output: string)
  : TArray<TDetectionResult>;
var
  JSONValue: TJSONValue;
  JSONObject: TJSONObject;
  DetectionsArray: TJSONArray;
  DetectionObj: TJSONObject;
  BBoxArray: TJSONArray;
  Results: TArray<TDetectionResult>;
  i: Integer;
  Success: Boolean;
begin
  SetLength(Results, 0);

  try
    // JSON を解析
    JSONValue := TJSONObject.ParseJSONValue(Output);
    if not Assigned(JSONValue) then
      raise Exception.Create('JSON の解析に失敗しました');

    try
      JSONObject := JSONValue as TJSONObject;
      Success := JSONObject.GetValue('success').AsType<Boolean>;

      if not Success then
      begin
        raise Exception.Create('検出処理でエラーが発生: ' + JSONObject.GetValue('error')
          .AsType<string>);
      end;

      DetectionsArray := JSONObject.GetValue('detections') as TJSONArray;
      SetLength(Results, DetectionsArray.Count);

      for i := 0 to DetectionsArray.Count - 1 do
      begin
        DetectionObj := DetectionsArray.Items[i] as TJSONObject;
        BBoxArray := DetectionObj.GetValue('bbox') as TJSONArray;

        Results[i].BBox[0] := BBoxArray.Items[0].AsType<Double>;
        Results[i].BBox[1] := BBoxArray.Items[1].AsType<Double>;
        Results[i].BBox[2] := BBoxArray.Items[2].AsType<Double>;
        Results[i].BBox[3] := BBoxArray.Items[3].AsType<Double>;
        Results[i].Confidence := DetectionObj.GetValue('confidence')
          .AsType<Double>;
        Results[i].ClassID := DetectionObj.GetValue('class_id').AsType<Integer>;
        Results[i].ClassName := DetectionObj.GetValue('class_name')
          .AsType<string>;
      end;

    finally
      JSONValue.Free;
    end;

  except
    on E: Exception do
    begin
      raise Exception.Create('YOLO検出エラー: ' + E.Message);
    end;
  end;

  Result := Results;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TForm1.DrawDetections(const Detections: TArray<TDetectionResult>);
var
  Bitmap: TBitmap;
  Canvas: TCanvas;
  X1, Y1, X2, Y2: Integer;
  ScaleX, ScaleY: Double;
  Text: string;
  TextRect: TRect;
begin
  if Length(Detections) = 0 then
    Exit;

  // 元画像を再読み込み

  Bitmap := TBitmap.Create;
  try
    Bitmap.Assign(Image1.Picture.Graphic);
    Canvas := Bitmap.Canvas;

    // スケール計算
    ScaleX := Bitmap.Width / Image1.Picture.Width;
    ScaleY := Bitmap.Height / Image1.Picture.Height;

    Canvas.Pen.Color := clLime;
    Canvas.Pen.Width := 3;
    Canvas.Brush.Style := TBrushStyle.bsClear;
    Canvas.Font.Color := clLime;
    Canvas.Font.Size := 10;
    Canvas.Font.Style := [fsBold];

    for var i := 0 to High(Detections) do
    begin
      X1 := Round(Detections[i].BBox[0] * ScaleX);
      Y1 := Round(Detections[i].BBox[1] * ScaleY);
      X2 := Round(Detections[i].BBox[2] * ScaleX);
      Y2 := Round(Detections[i].BBox[3] * ScaleY);

      // バウンディングボックス描画
      Canvas.Rectangle(X1, Y1, X2, Y2);

      // ラベル描画
      Text := Format('%s: %.1f%%', [Detections[i].ClassName,
        Detections[i].Confidence * 100]);

      Canvas.Brush.Color := clLime;
      Canvas.Brush.Style := bsSolid;
      TextRect := Rect(X1, Y1 - 20, X1 + Canvas.TextWidth(Text) + 4, Y1);
      Canvas.FillRect(TextRect);

      Canvas.Font.Color := clBlack;
      Canvas.TextOut(X1 + 2, Y1 - 18, Text);
      Canvas.Brush.Style := TBrushStyle.bsClear;
    end;

    Image1.Picture.Bitmap.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FYOLODetector := TYOLODetector.Create;
  TrackBar1.Position := 25; // 0.25の信頼度閾値
  lblConfidence.Caption := '0.25';
  LogMessage('YOLO物体検出アプリケーションを開始しました');
  LogMessage('Python環境とUltralyticsがインストールされている必要があります');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FYOLODetector.Free;
end;

procedure TForm1.LogMessage(const Msg: string);
begin
  Memo2.Lines.Add(Format('[%s] %s', [FormatDateTime('hh:nn:ss', Now), Msg]));
  Memo2.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  data: Double;
begin
  data := TrackBar1.Position / 100;
  lblConfidence.Caption := data.ToString;
  PythonDelphiVar2.Value := data;
end;

end.
