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
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Initialize device object and set it's media type
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            
            print("HELLOOOOOO")
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetaDataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetaDataOutput)
            
            captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetaDataOutput.metadataObjectTypes = supportedCodeTypes
            
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            // TODO: - Fix this and unwrap properly
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            barcodeFrame = UIView()
            
            if let barcodeFrame = barcodeFrame {
                barcodeFrame.layer.borderColor = UIColor.green.cgColor
                barcodeFrame.layer.borderWidth = 2
                view.addSubview(barcodeFrame)
                view.bringSubview(toFront: barcodeFrame)
                
            }
            
        } catch {
            // TODO: - Handle error!
            print("Error catching")
            return
        }
        
    
        
        

    }

}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        print("In the delegate method!")
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrame?.frame = CGRect.zero
            print("No barcode decoded")
        }
        
        // TODO: - Work on fixing this if barcode cannot be interpretted
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            print("Could not read this code")
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            self.barcodeFrame?.frame = (barcodeObject?.bounds)!
            
            print("This is the type: \(metadataObj.type)")
            print("This is the barcode value: \(metadataObj.stringValue)")
            
        } else {
            print("ERROOORRR")
        }
        
    }
    
    
}
