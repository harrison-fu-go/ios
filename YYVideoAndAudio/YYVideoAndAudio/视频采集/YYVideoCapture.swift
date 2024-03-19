//
//  YYVideoRecording.swift
//  YYVideoAndAudio
//
//  Created by HarrisonFu on 2024/2/28.
//

import UIKit
import AVFoundation

class YYVideoCapture: NSObject {
    
    static let share = YYVideoCapture()

/*    视频采集的步骤
    1、创建并初始化输入（AVCaptureInput）和输出（AVCaptureOutput）
    2、创建并初始化AVCaptureSession，把AVCaptureInput和AVCaptureOutput添加到AVCaptureSession中
    3、调用AVCaptureSession的startRunning开启采集 
*/
    
    func initCapture(position: AVCaptureDevice.Position = .front) -> AVCaptureDevice? {
        let discover =  AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                         mediaType: .video,
                                                         position: position)
        let targetDevice =  discover.devices.filter { (device) -> Bool in
            return device.position == AVCaptureDevice.Position.front
        }.first
        return targetDevice
    }
    
    func convertToInput(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let device = device else { return nil}
        do {
            let input = try? AVCaptureDeviceInput(device: device)
            return input
        }
    }
    
    
    
    
    
}
