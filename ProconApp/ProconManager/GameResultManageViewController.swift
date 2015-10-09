//
//  GameResultManageViewController.swift
//  ProconApp
//
//  Created by ito on 2015/09/13.
//  Copyright (c) 2015年 Procon. All rights reserved.
//

import UIKit
import AVFoundation
import APIKit
import ProconBase

class GameResultManageViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession = AVCaptureSession()
    
    var previewLayer: CALayer = CALayer()
    
    var capturedStrings: Set<String> = Set()
    
    var isSending: Bool = false
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var startStopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        layer.frame = previewView.bounds
        self.previewLayer = layer
        self.previewView.layer.addSublayer(layer)
        
        
        reloadButtonState()
        
        /*let data = NSData(contentsOfFile: "")
        let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        self.processQRCode(str as! String)
        */
        
        println(Constants.ManageAPIBaseURL)
        
        #if HOST_DEV
            self.navigationItem.title = "Dev"
        #elseif HOST_RELEASE
            self.navigationItem.title = "Prod"
        #endif
        
        #if HOST_RELEASE
        let alert = UIAlertController(title: "本番環境", message: Constants.ManageAPIBaseURL, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        #endif
    }
    
    func reloadButtonState() {
        if session.running {
            startStopButton.setTitle("読み取り停止", forState: .Normal)
        } else {
            startStopButton.setTitle("読み取り開始", forState: .Normal)
        }
    }
    
    @IBAction func startOrStopTapped(sender: AnyObject) {
        
        if session.running {
            session.stopRunning()
            for input in session.inputs {
                session.removeInput(input as! AVCaptureInput)
            }
            for output in session.outputs {
                session.removeOutput(output as! AVCaptureOutput)
            }
        } else {
            
            let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).filter {
                if let device = $0 as? AVCaptureDevice {
                    return device.position == .Back
                }
                return false
            }
            
            if devices.count == 0 {
                let alert = UIAlertController(title: "no device", message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if let device = devices.first as? AVCaptureDevice {
                let input = AVCaptureDeviceInput(device: device, error: nil)
                self.session.addInput(input)
                
                let output = AVCaptureMetadataOutput()
                self.session.addOutput(output)
                
                Logger.debug("\(output.availableMetadataObjectTypes)")
                if output.availableMetadataObjectTypes.count > 0 {
                    output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
                    output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                } else {
                    let alert = UIAlertController(title: "no detector", message: nil, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            session.startRunning()
        }
        
        self.reloadButtonState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.bounds
    }
    
    // MARK: Capture Delegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        for obj in metadataObjects {
            if let obj = obj as? AVMetadataMachineReadableCodeObject {
                if obj.type == AVMetadataObjectTypeQRCode, let str = obj.stringValue {
                    // QR Code detected
                    // base64 decode and decompress
                    let compressed = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    if let data = compressed?.pr_decompress(), let str = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                        self.processQRCode(str)
                    }
                }
            }
        }
    }
    
    func processQRCode(str: String) {
        if capturedStrings.contains(str) {
            return // already captured
        }
        if isSending {
            return
        }
        
        capturedStrings.insert(str)
        
        let alert = UIAlertController(title: "送信しますか？", message: str, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "送信", style: .Default, handler: { _ in
            self.sendQRCode(str)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.capturedStrings.remove(str)
        })
    }
    
    func showError(str: String) {
        let alert = UIAlertController(title: "パースエラー", message: str, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func sendQRCode(str: String) {
        
        let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        if data == nil {
            // TODO: guard
            showError("data conversion error")
            return
        }
        var error: NSError? = nil
        let obj = NSJSONSerialization.JSONObjectWithData(data!, options: .allZeros, error: &error) as? [String: AnyObject]
        if obj == nil || error != nil {
            showError("\(error ?? String())")
            return
        }
        
        let req = ManageAPI.Endpoint.UpdateGameResult(result: obj!)
        
        self.isSending = true
        
        let alert = UIAlertController(title: "送信中...", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        AppAPI.sendRequest(req) { res in
            self.isSending = false
            alert.dismissViewControllerAnimated(true) {
                switch res {
                case .Success(_):
                    break
                case .Failure(let box):
                    // TODO, error
                    Logger.error("\(box.value)")
                    self.showError("\(box.value)")
                }
            }
        }
    }
}
