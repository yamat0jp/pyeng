object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 786
  ClientWidth = 1025
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblConfidence: TLabel
    Left = 256
    Top = 368
    Width = 74
    Height = 15
    Caption = 'lblConfidence'
  end
  object Image1: TImage
    Left = 375
    Top = 32
    Width = 594
    Height = 697
    Proportional = True
    Stretch = True
  end
  object btnDetect: TButton
    Left = 160
    Top = 456
    Width = 75
    Height = 25
    Caption = 'btnDetect'
    TabOrder = 0
    OnClick = btnDetectClick
  end
  object TrackBar1: TTrackBar
    Left = 16
    Top = 360
    Width = 217
    Height = 45
    Max = 100
    Position = 25
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 31
    Top = 41
    Width = 314
    Height = 288
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object Button1: TButton
    Left = 63
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 120
    Top = 232
  end
end
