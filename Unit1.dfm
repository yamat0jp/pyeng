object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'localize YOLO'
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
  DesignSize = (
    1025
    786)
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
    Anchors = [akLeft, akTop, akRight, akBottom]
    Proportional = True
    Stretch = True
  end
  object Label1: TLabel
    Left = 8
    Top = 504
    Width = 68
    Height = 15
    Caption = 'Module Path'
  end
  object btnDetect: TButton
    Left = 158
    Top = 456
    Width = 75
    Height = 25
    Caption = 'btnDetect'
    TabOrder = 1
    OnClick = btnDetectClick
  end
  object TrackBar1: TTrackBar
    Left = 16
    Top = 360
    Width = 217
    Height = 45
    Max = 100
    Position = 25
    TabOrder = 2
    OnChange = TrackBar1Change
  end
  object Memo2: TMemo
    Left = 31
    Top = 41
    Width = 314
    Height = 288
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
  object Button1: TButton
    Left = 63
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Picture'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 400
    Top = 112
    Width = 529
    Height = 369
    Lines.Strings = (
      'import sys'
      'sys.path.append(path.value)'
      'import json'
      'from ultralytics.models import YOLO'
      'import numpy as np'
      ''
      
        'def detect_objects(image_path, model_path='#39'yolo11n.pt'#39', conf_thr' +
        'eshold=0.25):'
      '    try:'
      '        # '#12514#12487#12523#12434#35501#12415#36796#12415
      '        model = YOLO(model_path)'
      ''
      '        # '#25512#35542#23455#34892
      '        results = model(image_path, conf=conf_threshold)'
      ''
      '        # '#32080#26524#12434#35299#26512
      '        detections = []'
      '        for result in results:'
      '            boxes = result.boxes'
      '            if boxes is not None:'
      '                for box in boxes:'
      '                    # '#12496#12454#12531#12487#12451#12531#12464#12508#12483#12463#12473#12398#24231#27161
      '                    x1, y1, x2, y2 = box.xyxy[0].cpu().numpy()'
      '                    # '#20449#38972#24230
      
        '                    confidence = float(box.conf[0].cpu().numpy()' +
        ')'
      '                    # '#12463#12521#12473'ID'
      '                    class_id = int(box.cls[0].cpu().numpy())'
      '                    # '#12463#12521#12473#21517
      '                    class_name = model.names[class_id]'
      ''
      '                    detection = {'
      
        '                        '#39'bbox'#39': [float(x1), float(y1), float(x2)' +
        ', float(y2)],'
      '                        '#39'confidence'#39': confidence,'
      '                        '#39'class_id'#39': class_id,'
      '                        '#39'class_name'#39': class_name'
      '                    }'
      '                    detections.append(detection)'
      ''
      '        return {'
      '            '#39'success'#39': True,'
      '            '#39'detections'#39': detections,'
      '            '#39'count'#39': len(detections)'
      '        }'
      ''
      '    except Exception as e:'
      '        return {'
      '            '#39'success'#39': False,'
      '            '#39'error'#39': str(e)'
      '        }'
      ''
      ''
      '#    image_path = sys.argv[1]'
      'model_path = '#39'.\\yolo11n.pt'#39
      'conf_threshold = 0.25'
      ''
      '    # '#29289#20307#26908#20986#23455#34892
      
        'result = detect_objects(image.value, model_path, threshold.value' +
        ')'
      ''
      '    # '#32080#26524#12434'JSON'#24418#24335#12391#20986#21147
      'print(json.dumps(result, ensure_ascii=False, indent=2))')
    ScrollBars = ssVertical
    TabOrder = 4
    Visible = False
    WordWrap = False
  end
  object Memo3: TMemo
    Left = 63
    Top = 584
    Width = 267
    Height = 113
    Lines.Strings = (
      'Memo3')
    TabOrder = 5
    Visible = False
    WordWrap = False
  end
  object Edit1: TEdit
    Left = 8
    Top = 539
    Width = 328
    Height = 23
    TabOrder = 6
  end
  object Button2: TButton
    Left = 270
    Top = 456
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'End'
    TabOrder = 7
    OnClick = Button2Click
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 120
    Top = 232
  end
  object PythonEngine1: TPythonEngine
    IO = PythonGUIInputOutput1
    Left = 208
    Top = 160
  end
  object PythonGUIInputOutput1: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = Memo3
    Left = 296
    Top = 216
  end
  object PythonDelphiVar1: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'image'
    Left = 288
    Top = 448
  end
  object PythonDelphiVar2: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'threshold'
    Left = 288
    Top = 520
  end
  object PythonDelphiVar3: TPythonDelphiVar
    Engine = PythonEngine1
    Module = '__main__'
    VarName = 'path'
    Left = 288
    Top = 592
  end
end
