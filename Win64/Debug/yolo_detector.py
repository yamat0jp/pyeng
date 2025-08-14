
# yolo_detector.py
import sys
import json
from ultralytics import YOLO
import cv2
import numpy as np

def detect_objects(image_path, model_path='yolo11n.pt', conf_threshold=0.25):
    """
    YOLO v11を使用して物体検出を実行
    """
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

def save_annotated_image(image_path, output_path, detections):
    """
    検出結果を描画した画像を保存
    """
    img = cv2.imread(image_path)
    
    for det in detections:
        x1, y1, x2, y2 = [int(coord) for coord in det['bbox']]
        
        # バウンディングボックス描画
        cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
        
        # ラベル描画
        label = f"{det['class_name']}: {det['confidence']:.2f}"
        cv2.putText(img, label, (x1, y1-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 1)
    
    cv2.imwrite(output_path, img)

if __name__ == "__main__":
    if len(sys.argv) < 2:        
        sys.exit(1)
    
    image_path = sys.argv[1]
    model_path = sys.argv[2] if len(sys.argv) > 2 else 'yolo11n.pt'
    conf_threshold = float(sys.argv[3]) if len(sys.argv) > 3 else 0.25
    output_path = sys.argv[4] if len(sys.argv) > 4 else 'output_annotated.jpg'
    
    # 物体検出実行
    result = detect_objects(image_path, model_path, conf_threshold)
    
    # 結果をJSON形式で出力
    print(json.dumps(result, ensure_ascii=False, indent=2))
    
