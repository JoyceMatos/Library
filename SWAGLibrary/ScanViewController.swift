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
    
    // Properties
    
    
    @IBOutlet weak var cameraView: UIView!
    
    var barcodeFrame: UIView?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code]
    
    // View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAVFoundation()
    }
    
    // Barscanning method
    
    // TODO: - This method can be better
    func configureAVFoundation() {
        
        // Initialize device object and set it's media type
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            
            // Store input from device
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Create capture session and add input
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // Store output and add to session
            let captureMetaDataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetaDataOutput)
            
            // Select code types for output
            captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetaDataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Add session to preview layer and configure preview frame
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = cameraView.layer.bounds
            // TODO: - Fix this and unwrap properly
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            // Begin session
            captureSession?.startRunning()
            
            // Set up frame for barcode
            setupBarcodeView()
            
        } catch {
            // TODO: - Handle error!
            print("Error catching")
            return
        }
    }
    
    // TODO: - Separate into it's own view
    func setupBarcodeView() {
        barcodeFrame = UIView()
        
        if let barcodeFrame = barcodeFrame {
            barcodeFrame.layer.borderColor = UIColor.green.cgColor
            barcodeFrame.layer.borderWidth = 2
            cameraView.addSubview(barcodeFrame)
            cameraView.bringSubview(toFront: barcodeFrame)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

// AVCapture Method

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Set barcode's frame to zero if no data is detected
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrame?.frame = CGRect.zero
            print("No barcode decoded")
        }
        
        // TODO: - Work on fixing this if barcode cannot be interpretted
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            print("Could not read this code")
            return
        }
        
        // If data detected is compatible with barcode reader
        if supportedCodeTypes.contains(metadataObj.type) {
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            
            // TODO: - Unwrap this carefully
            self.barcodeFrame?.frame = (barcodeObject?.bounds)!
            
            print("This is the type: \(metadataObj.type)")
            print("This is the barcode value: \(metadataObj.stringValue)")
            
            // TODO: - Once barcode is captured, stop searching method and display pop up
            
        } else {
            
            // Handle this
            print("ERROOORRR")
        }
        
        
    }
    
    
}
