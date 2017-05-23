//
//  ScanViewController.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/23/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var barcodeFrame: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize device object and set it's media type
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        } catch {
            // TODO: - Handle error!
            print(error)
            return
        }
        
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetaDataOutput)
        
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode]
        
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        // TODO: - Fix this and unwrap properly
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
        
        

    }

}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    
    
}
