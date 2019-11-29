//
//  QRCodeScannerViewController.swift
//  Skroman
//
//  Created by ananadmahajan on 9/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import AVFoundation
import MQTTClient
import SVProgressHUD
protocol QRCodeScannerViewControllerDelegate : NSObjectProtocol {
    func didSuccess(ssid : String, password : String) -> Void;
    func didFailure() -> Void;
}


class QRCodeScannerViewController: BaseViewController,AVCaptureMetadataOutputObjectsDelegate,MQTTSessionDelegate {
    
    @IBOutlet weak var vwSeprator: UIView!
    @IBOutlet weak var vwBottomContainer: UIView!
    @IBOutlet weak var btnScanQrCode: UIButton!
    @IBOutlet weak var imagCorners: UIImageView!
    
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var strScannedQRCode : String? = ""
    var strBranchId : String? = ""
    var strAmount : String? = ""
    var captureDevice : AVCaptureDevice?
    var objSession : MQTTSession?
    var sessionConnected,sessionReceived,sessionError : Bool?
    var comefrom : QRCodeScannType?
    weak var delegate : QRCodeScannerViewControllerDelegate?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initViewController()
        self.backButtonSetup()
    }
    override func backButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding default navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func initViewController()
    {
        self.title = SSLocalizedString(key: "scan_qr_code")
        
        setFont()
        setColor()
        localizeText()
        
        
        
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        captureDevice = camera(with: .back)
        
        configureCamera()
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_SIZE.width, height: SCREEN_SIZE.height-58)
        view.layer.addSublayer(videoPreviewLayer!)
        
        view.bringSubview(toFront: self.vwBottomContainer)
        view.bringSubview(toFront: self.imagCorners)
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
    }
    func setFont()
    {
        btnScanQrCode.titleLabel?.font = Font_SanFranciscoText_Regular_H16
    }
    func setColor()
    {
        vwBottomContainer.backgroundColor = UICOLOR_BLUE
        btnScanQrCode.backgroundColor = UICOLOR_BLUE
        vwSeprator.backgroundColor = UICOLOR_SEPRATOR
    }
    func localizeText()
    {
        btnScanQrCode.setTitle(SSLocalizedString(key: "scan_qr_code").uppercased(), for: .normal)
        btnScanQrCode.setTitle(SSLocalizedString(key: "scan_qr_code").uppercased(), for: .selected)
    }
    func configureCamera() {
        let err: Error? = nil
        let newVideoInput = try? AVCaptureDeviceInput(device: captureDevice!)
        if newVideoInput == nil || err != nil {
            print("Error creating capture device input: \(err?.localizedDescription ?? "")")
        } else {
            if let anInput = newVideoInput {
                captureSession.addInput(anInput)
                
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            }
        }
        captureSession.commitConfiguration()
        
        captureSession.startRunning()
    }
    func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        if #available(iOS 10.0, *) {
            captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: position)
        } else {
            if position == .front {
                ToastMessage.showInfoMessage(SSLocalizedString(key: "does_not_support"))
            }
        }
        
        
        let devices = AVCaptureDevice.devices(for: .video)
        for device: AVCaptureDevice in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("metadataOutput ")
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                qrCodeFrameView?.frame = CGRect.zero
                
                //                ToastMessage.showInfoMessage("QR Code String \(String(describing: metadataObj.stringValue))")
                strScannedQRCode = metadataObj.stringValue
                if(!(strScannedQRCode?.isEmpty)!)
                {//ssid:%@-pwd:%@
                    //QR code should start with ssid and should contain -pwd
                    if((strScannedQRCode?.hasPrefix("ssid:"))! && (strScannedQRCode?.contains("-pwd:"))!)
                    {
                        self.connectToAutoWifi(strScannedQRCode: strScannedQRCode!);
                        
                    }
                    else
                    {
                        print("INVALID QR code \(String(describing: strScannedQRCode))")
                        self.invalidQRCode()
                    }
                    
                    
                }
                else
                {
                    
                    self.invalidQRCode()
                }
                captureSession.stopRunning()
                
                
                
            }
        }
    }
    //MARK:- IBAction
    @IBAction func tappedScanQrCode(_ sender: Any) {
        SSLog(message: "tappedScanQrCode")
        UIAppDelegate.navigateToHomeScreen()
    }
    func invalidQRCode() {
        self.delegate?.didFailure();
        SVProgressHUD.dismiss()
        self.showAlertMessage(strMessage: SSLocalizedString(key: "invalid_qr_code_for_home"))
        self.dismiss(animated: true, completion: nil)
        
    }
    func connectToAutoWifi(strScannedQRCode : String)
    {
        print("valid QR code")
        let ssid = Utility.getSSIDFromQRCodeString(strScannedQRCode)
        let password = Utility.getSDDIPasswordFromQRCodeString(strScannedQRCode);
        print(SSID.fetchSSIDInfo())
        
        if ssid == SSID.fetchSSIDInfo()
        {
            self.dismiss(animated: true, completion: {
                SVProgressHUD.show(withStatus:SSLocalizedString(key:"connecting_to_device"))
                self.delegate?.didSuccess(ssid: ssid, password: password)
            })
        }
        else
        {
            typealias Network = HotspotManager.Network
            let network = Network(
                ssid: ssid,
                password: password,
                isWEP: false,
                joinOnce: false //it will always connect..even app closed
            )
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            SVProgressHUD.show(withStatus:SSLocalizedString(key:"connecting_to_wifi"))
            
            appDelegate.manager.add(network: network) { (error) in
                if let error = error as NSError? {
                    NSLog("did not add '%@', error %@ / %d", network.ssid, error.domain, error.code)
                    //gaurav  self.showAlertMessage(strMessage: SSLocalizedString(key: "unable_to_connect") as NSString)
                    self.dismiss(animated: true, completion: {
                        
                        //TO REMOVE WIFI
                        UIAppDelegate.manager.remove(ssid: ssid, completion: { (err) in
                            
                        })
                        
                        self.delegate?.didFailure()
                        SVProgressHUD.dismiss()
                    })
                    SVProgressHUD.dismiss()
                }
                else
                {
                    ////gaurav self.showAlertMessage(strMessage: SSLocalizedString(key: "qr_code_successfully_scanned") as NSString)
                    self.dismiss(animated: true, completion: {
                        SVProgressHUD.show(withStatus:SSLocalizedString(key:"connecting_to_device"))
                        self.delegate?.didSuccess(ssid: ssid, password: password)
                    })
                }
            }
        }
    }
}
