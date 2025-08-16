import sys
import json
from ultralytics import YOLO
import numpy as np

def detect_objects(image_path, model_path='yolo11n.pt', conf_threshold=0.25):
    try:
        # モデルを読み込み
        model = YOLO(model_path)

        # 推論実行
        results = model(image_path, conf=conf_threshold)

        # 結果を解析
        detections = []
        for result in results:
            boxes = result.boxes
            if boxes is not None:
                for box in boxes:
                    # バウンディングボックスの座標
                    x1, y1, x2, y2 = box.xyxy[0].cpu().numpy()
                    # 信頼度
                    confidence = float(box.conf[0].cpu().numpy())
                    # クラスID
                    class_id = int(box.cls[0].cpu().numpy())
                    # クラス名
                    class_name = model.names[class_id]

                    detection = {
                        'bbox': [float(x1), float(y1), float(x2), float(y2)],
                        'confidence': confidence,
                        'class_id': class_id,
                        'class_name': class_name
                    }
                    detections.append(detection)

        return {
            'success': True,
            'detections': detections,
            'count': len(detections)
        }

    except Exception as e:
        return {
            'success': False,
            'error': str(e)
        }

def main():
#    image_path = sys.argv[1]
    model_path = 'yolo11n.pt'
    conf_threshold = 0.25

    # 物体検出実行
    return detect_objects(image.value, model_path, conf_threshold)

    # 結果をJSON形式で出力
#    print(json.dumps(result, ensure_ascii=False, indent=2))

