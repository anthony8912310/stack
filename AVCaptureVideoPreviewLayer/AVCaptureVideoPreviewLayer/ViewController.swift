//
//  ViewController.swift
//  AVCaptureVideoPreviewLayer
//
//  Created by admin on 2021/3/11.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate{
    
    
    @IBOutlet weak var forPreview: UIView!
    //負責處理輸入裝置->輸出間的資料流動
    let session = AVCaptureSession()
    //負責設定好輸出段擷取裝置
    let deviceInput = DeviceInput()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //設定預覽圖層
        settingPreviewLayer()
        
        //將麥克風連結到協調器
        session.addInput(deviceInput.microphone!)
        //將後置廣角鏡頭連結到協調器
        session.addInput(deviceInput.backWildAngleCamera!)
        
        //設定輸出品質為最高解析度
        session.sessionPreset = .photo
        //設定輸出端格式為照片
        session.addOutput(AVCapturePhotoOutput())
        
        //錄影品質為1280x728
        session.sessionPreset = .hd1280x720
        //設定輸出端為QuickTime影片
        session.addOutput(AVCaptureMovieFileOutput())
        
        //讓資料開始流入
        session.startRunning()
    }
    //自訂一個 預覽圖層 func
    func settingPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.frame = forPreview.bounds
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        forPreview.layer.addSublayer(previewLayer)
        
    }
    
    @IBAction func frontBackToggle(_ sender: UISwitch) {
        //修改session開始
        session.beginConfiguration()
        
        //將現有的input刪除
        session.removeInput(session.inputs.last!)
        
        if sender.isOn {
            //後置鏡頭
            session.addInput(deviceInput.backWildAngleCamera!)
        }else{
            //前置鏡頭
            session.addInput(deviceInput.frontWildAngleCamera!)

        }
        //確認修改
        session.commitConfiguration()
    }
    //設定按下快門要做的事
    @IBAction func takeButton(_ sender: UIButton) {
        let setting = AVCapturePhotoSettings()
        //強制開啟閃光燈
        setting.flashMode = .on
        
        let output = session.outputs.first! as! AVCapturePhotoOutput
        //呼叫capturePhoto
        output.capturePhoto(with: setting, delegate: self)
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let image = UIImage(data: photo.fileDataRepresentation()!)
        //照片存擋
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    //先設定協調器中鏡頭與麥克風暫存檔的位置
    //呼叫startRecording
    @IBAction func startRecord(_ sender: UIButton) {
         //影片暫存path /tmp/output.mov
        let url = URL(fileURLWithPath: NSTemporaryDirectory()+"output.mov")
        //開始錄影
        let output = session.outputs.first! as! AVCaptureMovieFileOutput
        output.startRecording(to: url, recordingDelegate: self)
    }
    //呼叫stopRecording
    @IBAction func stopRecoed(_ sender: UIButton) {
        let output = session.outputs.first! as! AVCaptureMovieFileOutput
        output.stopRecording()
    }
    //在stopRecording被呼叫後執行
    //將 暫存檔的資料 複製到 相機膠卷
    //複製完將暫存檔刪除
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFileURL.path) {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, #selector(completion(_:error:contextInfo:)), nil)
        }
    }
    
    @objc func completion(_ videoPath:String,error:Error?,contextInfo:Any?){
        //影片存檔完成後刪除暫存檔
        do{
            let fm = FileManager.default
            try fm.removeItem(atPath: videoPath)
        }catch{
            print(error)
        }
    }
}

