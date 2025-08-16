object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Memo1: TMemo
    Left = 88
    Top = 63
    Width = 377
    Height = 233
    Lines.Strings = (
      'import pandas as pd'
      'from sklearn.datasets import load_iris'
      'from sklearn.cluster import KMeans'
      ''
      'iris = load_iris()'
      ''
      'distortion = {}'
      ''
      'for i in range(2, 100):'
      '  kmeans = KMeans(init='#39'random'#39',n_clusters=i)'
      '  kmeans.fit(iris.data)'
      '  distortion[i] = kmeans.inertia_'
      ''
      'pd.Series(distortion).plot.line()')
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 88
    Top = 302
    Width = 377
    Height = 89
    Lines.Strings = (
      'Memo2')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 182
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object PythonEngine1: TPythonEngine
    IO = PythonGUIInputOutput1
    Left = 176
    Top = 72
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = Memo2
    Left = 328
    Top = 72
  end
  object PythonModule1: TPythonModule
    Engine = PythonEngine1
    ModuleName = 'pandas'
    Errors = <>
    Left = 280
    Top = 136
  end
  object PythonModule2: TPythonModule
    Engine = PythonEngine1
    ModuleName = 'sklearn'
    Errors = <>
    Left = 432
    Top = 136
  end
end
