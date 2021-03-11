//
//  DeviceInput.swift
//  inputOutput
//
//  Created by admin on 2021/3/11.
//

import UIKit
import AVFoundation
class DeviceInput: NSObject {
    //前置廣角鏡頭
    var frontWildAngleCamera : AVCaptureDeviceInput?
    //後置廣角鏡頭
    var backWildAngleCamera : AVCaptureDeviceInput?
    //後置望遠鏡頭
    var backTelephotoCamera : AVCaptureDeviceInput?
    //後置雙鏡頭
    var backDualCamera : AVCaptureDeviceInput?
    //麥克風
    var microphone : AVCaptureDeviceInput?
    
    //實作取得所有鏡頭裝置
    func getAllCamera() {
        //取得所有鏡頭
        let cameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,.builtInTelephotoCamera,.builtInDualCamera], mediaType: .video, position: .unspecified).devices
        
        for camera in cameraDevices {
            let inputDevices = try! AVCaptureDeviceInput(device: camera)
            
            if camera.deviceType == .builtInWideAngleCamera,camera.position == .front {
                frontWildAngleCamera = inputDevices
            }
            
            if camera.deviceType == .builtInWideAngleCamera,camera.position == .back {
                backWildAngleCamera = inputDevices
            }
            
            if camera.deviceType == .builtInTelephotoCamera {
                backTelephotoCamera = inputDevices
            }
            
            if camera.deviceType == .builtInDualCamera {
                backDualCamera = inputDevices
            }
            
        }

    }
    //實作取得麥克風
    func getMicrophone() {
        //取得麥克風
        if let mic = AVCaptureDevice.default(for: .audio){
            microphone = try! AVCaptureDeviceInput(device: mic)
        }
    }
    override init() {
        super.init()
        getAllCamera()
        getMicrophone()
    }
}
