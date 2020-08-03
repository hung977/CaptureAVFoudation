//
//  ViewController.swift
//  AVFoudationExample
//
//  Created by admin on 8/3/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var process = 0
    let session = AVCaptureSession()
    var camera : AVCaptureDevice?
    var cameraCaptureInput: AVCaptureDeviceInput?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var decriptionLabel: UILabel!
    @IBOutlet weak var overlayImage: UIImageView!
    var cameraCaptureOutput : AVCapturePhotoOutput?
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCaptureSession(position: .back)
    }
    @IBAction func captureTapped(_ sender: UIButton) {
        if process == 2 {
            process = 0
        } else {
            process += 1
        }
        if process == 1 {
            textLabel.text = "Ảnh mặt sau"
            decriptionLabel.text = "Vui lòng chụp ảnh mặt trước trong điều kiện đủ sáng và không bị nghiêng, mờ."
            overlayImage.image = UIImage(named: "overlay")
            
        } else if process == 2 {
            switchCamera()
            textLabel.text = "Ảnh chân dung"
            decriptionLabel.text = "Vui lòng giữ khuông mặt trong khung hình, chụp đủ sáng và không bị nghiêng, mờ"
            overlayImage.image = UIImage(named: "Subtraction-1")
        }
        takePicture()
    }
    @IBAction func cancelTapped(_ sender: UIButton) {
        print("Tappedddd")
    }
    func switchCamera() {
        session.stopRunning()
        session.removeInput(cameraCaptureInput!)
        session.removeOutput(cameraCaptureOutput!)
        initializeCaptureSession(position: .front)
    }
    func initializeCaptureSession(position: AVCaptureDevice.Position) {
        session.sessionPreset = AVCaptureSession.Preset.high
        camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position)
        
        
        do {
            cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
            cameraCaptureOutput = AVCapturePhotoOutput()
            
            session.addInput(cameraCaptureInput!)
            session.addOutput(cameraCaptureOutput!)
            
        } catch {
            print(error.localizedDescription)
        }
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.bounds
        cameraPreviewLayer?.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
        
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        session.startRunning()
    }
    
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
    }
}
extension ViewController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let unwapError = error {
            print(unwapError.localizedDescription)
        } else {
            if let imageData = photo.fileDataRepresentation() {
                if let uiImage = UIImage(data: imageData) {
                    //NotificationCenter.default.post(name: .didCapturePhoto, object: uiImage)
                    print(uiImage.size)
                }
            }
        }
    }
}
extension Notification.Name {
    static let didCapturePhoto = Notification.Name("didCapturePhoto")
    
}


