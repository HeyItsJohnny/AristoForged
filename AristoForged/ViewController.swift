//
//  ViewController.swift
//  AristoForged
//
//  Created by Paras Navadiya on 3/11/17.
//  Copyright © 2017 SanDataSystem. All rights reserved.
//

import UIKit
import AVFoundation
import Social

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate, AVCapturePhotoCaptureDelegate
{
    @IBOutlet var btnShare: UIButton!
    
    @IBOutlet var btnWheels: UIButton!
    
    @IBOutlet var btnChangeCar: UIButton!
    
    @IBOutlet var btnSaveToCameraRoll: UIButton!
    
    @IBOutlet var selectCarVw: UIView!
    
    @IBOutlet var btnPhotoGallery: UIButton!
    
    @IBOutlet var btnCamera: UIButton!
    
    @IBOutlet var btnSampleCars: UIButton!
    
    @IBOutlet var sharingVw: UIView!
    
    @IBOutlet var btnFacebook: UIButton!
    
    @IBOutlet var btnTwitter: UIButton!
    
    @IBOutlet var btnInstagram: UIButton!
    
    @IBOutlet var carMainVw: UIView!
    
    @IBOutlet var carMainImage: UIImageView!
    
    @IBOutlet var menuVw: UIView!
    
    @IBOutlet var btnCategory: UIButton!
    
    @IBOutlet var btnViewGallery: UIButton!
    
    @IBOutlet var btnSelectCar: UIButton!
    
    @IBOutlet var wheelCategoryVw: UIView!
    
    @IBOutlet var tableCategory: UITableView!
    
    @IBOutlet var wheelVw: UIView!
    
    @IBOutlet var lblWheelCategory: UILabel!
    
    @IBOutlet var btnCloseCategory: UIButton!
    
    @IBOutlet var lblWheelName: UILabel!
    
    @IBOutlet var collectionWheel:UICollectionView!
    
    @IBOutlet var lblCarName: UILabel!
    
    @IBOutlet var btnCloseCar: UIButton!
    
    @IBOutlet var collectionCar: UICollectionView!
    
    @IBOutlet var sampleCarVw: UIView!
    
    @IBOutlet var howToUseVw: UIView!
    
    @IBOutlet var btnDoneHowToUse: UIButton!
    
    @IBOutlet var btnUrbanCam: UIButton!
    
    @IBOutlet var wheelBGVw1: UIView!
    @IBOutlet var wheelBGVw2: UIView!
    
    @IBOutlet var imgWheel1: UIImageView!
    @IBOutlet var imgWheel2: UIImageView!
    
    var  arrWheels = NSMutableArray()
    
    var arrSelectedWheelCat = NSMutableArray()
    
    var  arrSmallCar = NSMutableArray()
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    //var imageOutput: AVCaptureStillImageOutput?
    var imageOutput: AVCapturePhotoOutput?
    var focusView: UIView?
    
    var flashOffImage: UIImage?
    var flashOnImage: UIImage?
    
    @IBOutlet var cameraView: UIView!
    
    @IBOutlet var btnCloseCameraView: UIButton!
    @IBOutlet var btnCapture: UIButton!
    
    @IBOutlet var botVw: UIView!
    @IBOutlet var btnNextWheel: UIButton!
    @IBOutlet var btnPrevWheel: UIButton!
    @IBOutlet var btnInquir: UIButton!
    @IBOutlet var lblSelectedCatName: UILabel!
    @IBOutlet var lblSelectedWheelName: UILabel!
    
    var videoLayer : AVCaptureVideoPreviewLayer?
    
    var documentController: UIDocumentInteractionController!
   
    var  arrAllWheels = NSMutableArray()
    
    var counter = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isDone")
        {
            hideView(view: howToUseVw)
        }
        else
        {
            showView(view: howToUseVw)
        }
        
        arryAllWheels()
        setWheelsAndCar()
        collectionCar.reloadData()
        hideAllViews()
        
        counter = 0
        let dictWheelCat = arrAllWheels.object(at: counter) as! NSDictionary
        
        lblSelectedCatName.text = dictWheelCat.value(forKey: "cat_name") as? String
        
        let strImgName = dictWheelCat.value(forKey: "wheel_name") as? String
        lblSelectedWheelName.text = strImgName
        
        imgWheel1.image = UIImage(named: strImgName!)
        imgWheel2.image = UIImage(named: strImgName!)
        
        

        addMovementGesturesToView(bgView: wheelBGVw1)
        addMovementGesturesToView(bgView: wheelBGVw2)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAllViews))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        let tap1 = UITapGestureRecognizer(target: self, action : #selector(doNothing))
        tap1.numberOfTapsRequired = 1
        tap1.cancelsTouchesInView = false
        sampleCarVw.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action : #selector(doNothing))
        tap2.numberOfTapsRequired = 1
        tap2.cancelsTouchesInView = false
        wheelVw.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action : #selector(doNothing))
        tap3.numberOfTapsRequired = 1
        tap3.cancelsTouchesInView = false
        menuVw.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action : #selector(doNothing))
        tap4.numberOfTapsRequired = 1
        tap4.cancelsTouchesInView = false
        wheelCategoryVw.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action : #selector(doNothing))
        tap5.numberOfTapsRequired = 1
        tap5.cancelsTouchesInView = false
        cameraView.addGestureRecognizer(tap5)
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMenu))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return [.landscapeRight, .landscapeLeft]
        }
    }
    
    open override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    @objc func rotated()
    {
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        print(orientation)
        
        switch (orientation)
        {
        case .landscapeRight:
            videoLayer?.connection!.videoOrientation = .landscapeLeft
        case .landscapeLeft:
            videoLayer?.connection!.videoOrientation = .landscapeRight
        default:
            videoLayer?.connection!.videoOrientation = .landscapeRight
        }
    }
    
    @objc func doNothing(){}
    
    @objc func showMenu()
    {
        hideAllViews()
        showView(view: menuVw)
    }
    
    func hideView(view: UIView)
    {
        self.view.sendSubviewToBack(view)
        view.isHidden = true
    }
    
    func showView(view: UIView)
    {
        self.view.bringSubviewToFront(view)
        view.isHidden = false
    }
    
    @objc func hideAllViews()
    {
        hideView(view: selectCarVw)
        hideView(view: sharingVw)
        hideView(view: menuVw)
        hideView(view: wheelCategoryVw)
        hideView(view: wheelVw)
        hideView(view: sampleCarVw)
        hideView(view: cameraView)
    }
    
    
    @IBAction func btnDoneHowToUse(_ sender: Any)
    {
        UserDefaults.standard.set(true, forKey: "isDone")
        UserDefaults.standard.synchronize()
        hideView(view: howToUseVw)
    }
    
    @IBAction func btnShare(_ sender: Any)
    {
        //        if sharingVw.isHidden
        //        {
        hideAllViews()
        showView(view: sharingVw)
        //        }
        //        else
        //        {
        //            hideView(view: sharingVw)
        //        }
    }
    
    @IBAction func btnWheels(_ sender: Any)
    {
        //        if menuVw.isHidden
        //        {
        hideAllViews()
        showView(view: menuVw)
        //        }
        //        else
        //        {
        //            hideView(view: menuVw)
        //        }
    }
    
    @IBAction func btnChangeCar(_ sender: Any)
    {
        //        if selectCarVw.isHidden
        //        {
        hideAllViews()
        showView(view: selectCarVw)
        //        }
        //        else
        //        {
        //            hideView(view: selectCarVw)
        //        }
    }
    
    @IBAction func btnSaveToCameraRoll(_ sender: Any)
    {
        let layer = carMainVw.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(carMainVw.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        let alert = UIAlertController(title: "AristoForged", message: "Image saved to camera roll", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnPhotoGallery(_ sender: Any)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnCamera(_ sender: Any)
    {
        //        if cameraView.isHidden
        //        {
        hideAllViews()
        showView(view: cameraView)
        initialize()
        //        }
        //        else
        //        {
        //            hideView(view: cameraView)
        //        }
    }
    
    func initialize() {
        
        if session != nil {
            return
        }
        
        
        // AVCapture
        session = AVCaptureSession()
        
        /*
        for device in AVCaptureDevice.devices() {
            
            if let device = device as? AVCaptureDevice , device.position == AVCaptureDevice.Position.back {
                
                self.device = device
            }
        }*/
        
        self.device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        
        
        do {
            
            if let session = session {
                
                videoInput = try AVCaptureDeviceInput(device: device!)
                
                session.addInput(videoInput!)
                
                //imageOutput = AVCaptureStillImageOutput()
                imageOutput = AVCapturePhotoOutput()
                
                session.addOutput(imageOutput!)
                
                videoLayer = AVCaptureVideoPreviewLayer(session: session)
                videoLayer?.frame = cameraView.bounds
                videoLayer?.videoGravity = AVLayerVideoGravity(rawValue: convertFromAVLayerVideoGravity(AVLayerVideoGravity.resizeAspectFill))
                cameraView.layer.addSublayer(videoLayer!)
                
                cameraView.addSubview(btnCloseCameraView)
                cameraView.addSubview(btnCapture)
                
                let orientation: UIDeviceOrientation = UIDevice.current.orientation
                print(orientation)
                
                switch (orientation)
                {
                case .portrait:
                    videoLayer?.connection!.videoOrientation = .portrait
                case .landscapeRight:
                    videoLayer?.connection!.videoOrientation = .landscapeLeft
                case .landscapeLeft:
                    videoLayer?.connection!.videoOrientation = .landscapeRight
                default:
                    videoLayer?.connection!.videoOrientation = .landscapeRight
                }
                
                session.sessionPreset = AVCaptureSession.Preset(rawValue: convertFromAVCaptureSessionPreset(AVCaptureSession.Preset.photo))
                session.startRunning()
            }
        }
        catch
        {
            
        }
        
        self.startCamera()
    }
    
    func startCamera() {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
        
        if status == AVAuthorizationStatus.authorized {
            
            session?.startRunning()
            
        } else if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted {
            
            session?.stopRunning()
        }
    }
    
    func stopCamera() {
        session?.stopRunning()
    }
    
    @IBAction func btnSampleCars(_ sender: Any)
    {
        hideAllViews()
        showView(view: menuVw)
        showView(view: sampleCarVw)
    }
    
    @IBAction func btnFacebook(_ sender: Any)
    {
        let app = UIApplication.shared
        let appScheme = "fb://app"
        if app.canOpenURL(URL(string: appScheme)!) {
            let layer = carMainVw.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(carMainVw.frame.size, false, scale);
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                vc.setInitialText("Look at this great picture!")
                vc.add(screenshot)
                present(vc, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "AristoForged", message: "Facebook application isn't installed in your device. Please install the Facebook app to post the picture.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        /*
        let layer = carMainVw.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(carMainVw.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText("Look at this great picture!")
            vc.add(screenshot)
            present(vc, animated: true)
        }*/
    }
    
    @IBAction func btnTwitter(_ sender: Any)
    {
        let app = UIApplication.shared
        let appScheme = "twitter://app"
        if app.canOpenURL(URL(string: appScheme)!) {
            let layer = carMainVw.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(carMainVw.frame.size, false, scale);
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            {
                vc.setInitialText("Look at this great picture!")
                vc.add(screenshot)
                present(vc, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "AristoForged", message: "Twitter application isn't installed in your device. Please install the twitter app to post a new picture.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        /*
        let layer = carMainVw.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(carMainVw.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        {
            vc.setInitialText("Look at this great picture!")
            vc.add(screenshot)
            present(vc, animated: true)
        }*/
    }
    
    @IBAction func btnInstagram(_ sender: Any)
    {
        //let instagramURL = NSURL(string: "instagram://app")
        let instagramURL = NSURL(string: "https://www.instagram.com/create/story")
        if (UIApplication.shared.canOpenURL(instagramURL! as URL)) {
            
            let layer = carMainVw.layer
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(carMainVw.frame.size, false, scale);
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let imageData = screenshot!.jpegData(compressionQuality: 100)
            
            let captionString = "caption"
            
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            try! imageData?.write(to: URL.init(fileURLWithPath: writePath), options: .atomicWrite)
            
            let fileURL = NSURL(fileURLWithPath: writePath)
            
            self.documentController = UIDocumentInteractionController(url: fileURL as URL)
            
            self.documentController.delegate = self
            
            self.documentController.uti = "com.instagram.exlusivegram"
            
            self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
            self.documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
            
        }
        else
        {
            let alert = UIAlertController(title: "AristoForged", message: "Instagram application isn't installed in your device", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnUrbanCam(_ sender: Any)
    {
        UIApplication.shared.open(NSURL(string: "https://itunes.apple.com/us/app/urbancam/id1063946606?ls=1&mt=8")! as URL)
    }
    
    @IBAction func btnCategory(_ sender: Any)
    {
        //        if wheelCategoryVw.isHidden
        //        {
        hideAllViews()
        showView(view: menuVw)
        showView(view: wheelCategoryVw)
        //        }
        //        else
        //        {
        //            hideView(view: wheelCategoryVw)
        //        }
    }
    
    @IBAction func btnViewGallery(_ sender: Any) {
        
    }
    
    @IBAction func btnSelectCar(_ sender: Any)
    {
        collectionCar.reloadData()
        
        //        if sampleCarVw.isHidden
        //        {
        hideAllViews()
        showView(view: menuVw)
        showView(view: sampleCarVw)
        //        }
        //        else
        //        {
        //            hideView(view: sampleCarVw)
        //        }
    }
    
    @IBAction func btnCloseCategory(_ sender: Any)
    {
        hideView(view: wheelVw)
        showView(view: wheelCategoryVw)
    }
    
    @IBAction func btnCloseCar(_ sender: Any)
    {
        hideView(view: sampleCarVw)
    }
    
    @IBAction func btnCloseCameraView(_ sender: Any)
    {
        self.hideAllViews()
        
        self.session     = nil
        self.device      = nil
        self.imageOutput = nil
    }
    
    @IBAction func btnCapture(_ sender: Any)
    {
        guard let imageOutput = imageOutput else
        {
            return
        }
        
        DispatchQueue.global(qos: .default).async(execute: { () -> Void in
            
            let videoConnection = imageOutput.connection(with: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
            
            let orientation: UIDeviceOrientation = UIDevice.current.orientation
            switch (orientation) {
            case .landscapeRight:
                videoConnection?.videoOrientation = .landscapeLeft
            case .landscapeLeft:
                videoConnection?.videoOrientation = .landscapeRight
            default:
                videoConnection?.videoOrientation = .landscapeRight
            }
            let settings = AVCapturePhotoSettings()
            //imageOutput.capturePhoto(with: settings, delegate: self)        //NEW
            
            //OLD COMMENTED CODE OUT..
            imageOutput.capturePhoto(with: settings, delegate: self)
            /*imageOutput.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (buffer, error) -> Void in
                
                self.session?.stopRunning()
                
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)
                
                self.carMainImage.image = UIImage(data: data!, scale: 1)
                
                self.carMainImage.contentMode = .scaleAspectFill
                
                self.hideAllViews()
                
                self.session     = nil
                self.device      = nil
                self.imageOutput = nil
                
            })*/
        })
    }
    
    @IBAction func btnNextWheel(_ sender: Any)
    {
        counter = counter + 1
        
        if counter > (arrAllWheels.count - 1)
        {
            counter = 10
            return
        }
        
        let dictWheelCat = arrAllWheels.object(at: counter) as! NSDictionary
        
        lblSelectedCatName.text = dictWheelCat.value(forKey: "cat_name") as? String
        
        let strImgName = dictWheelCat.value(forKey: "wheel_name") as? String
        lblSelectedWheelName.text = strImgName
        
        imgWheel1.image = UIImage(named: strImgName!)
        imgWheel2.image = UIImage(named: strImgName!)
    }
    
    @IBAction func btnPrevWheel(_ sender: Any)
    {
        counter = counter - 1
        
        if counter < 0
        {
            counter = 0
            return
        }
        
        let dictWheelCat = arrAllWheels.object(at: counter) as! NSDictionary
        
        lblSelectedCatName.text = dictWheelCat.value(forKey: "cat_name") as? String
        
        let strImgName = dictWheelCat.value(forKey: "wheel_name") as? String
        lblSelectedWheelName.text = strImgName
        
        imgWheel1.image = UIImage(named: strImgName!)
        imgWheel2.image = UIImage(named: strImgName!)
    }
    
    @IBAction func btnInquir(_ sender: Any)
    {
        let websiteViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebsiteViewController") as? UCWebsiteViewController
        websiteViewController!.websiteURLString = "http://aristoforgedwheels.com/contact/"
        websiteViewController!.navTitle = "Inquir"
        self.present(websiteViewController!, animated: true, completion: nil)
    }
    
    func arryAllWheels() {
        
        var dictTemp = NSMutableDictionary()

        dictTemp.setValue("Cs5y" , forKey: "wheel_name")
        dictTemp.setValue("Concave Series" , forKey: "cat_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Concave Series" , forKey: "cat_name")
        dictTemp.setValue("CS5vStepLip" , forKey: "wheel_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Concave Series" , forKey: "cat_name")
        dictTemp.setValue("Cs5vStepLip2tone" , forKey: "wheel_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Concave Series" , forKey: "cat_name")
        dictTemp.setValue("CS14" , forKey: "wheel_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Concave Series" , forKey: "cat_name")
        dictTemp.setValue("CS14StepLip" , forKey: "wheel_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Luxury10Split" , forKey: "wheel_name")
        dictTemp.setValue("Luxury Series" , forKey: "cat_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Luxury21" , forKey: "wheel_name")
        dictTemp.setValue("Luxury Series" , forKey: "cat_name")
        arrAllWheels.add(dictTemp)

        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Sport16" , forKey: "wheel_name")
        dictTemp.setValue("Mt series" , forKey: "cat_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Mt series" , forKey: "cat_name")
        dictTemp.setValue("Mt5y" , forKey: "wheel_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Mt series" , forKey: "cat_name")
        dictTemp.setValue("Twist10" , forKey: "wheel_name")
        arrAllWheels.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Sport Series" , forKey: "cat_name")
        dictTemp.setValue("SportY5" , forKey: "wheel_name")
        arrAllWheels.add(dictTemp)
    }
    
    func setWheelsAndCar()  {
        
        var dictWheel = NSMutableDictionary()
        dictWheel.setValue("Concave Series" , forKey: "cat_name")
        
        var  arrTemp = NSMutableArray()
        
        var dictTemp = NSMutableDictionary()
        dictTemp.setValue("Cs5y" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("CS5vStepLip" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Cs5vStepLip2tone" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("CS14" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("CS14StepLip" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        dictWheel.setValue(arrTemp, forKey: "wheels")
        arrWheels.add(dictWheel)
        
        dictWheel = NSMutableDictionary()
        dictWheel.setValue("Luxury Series" , forKey: "cat_name")
        
        arrTemp = NSMutableArray()
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Luxury10Split" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Luxury21" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        dictWheel.setValue(arrTemp, forKey: "wheels")
        arrWheels.add(dictWheel)
        
        dictWheel = NSMutableDictionary()
        dictWheel.setValue("Mt series" , forKey: "cat_name")
        
        arrTemp = NSMutableArray()
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Sport16" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Mt5y" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("Twist10" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        dictWheel.setValue(arrTemp, forKey: "wheels")
        arrWheels.add(dictWheel)
        
        
        dictWheel = NSMutableDictionary()
        dictWheel.setValue("Sport Series" , forKey: "cat_name")
        arrTemp = NSMutableArray()
        
        dictTemp = NSMutableDictionary()
        dictTemp.setValue("SportY5" , forKey: "wheel_name")
        arrTemp.add(dictTemp)
        
        dictWheel.setValue(arrTemp, forKey: "wheels")
        arrWheels.add(dictWheel)
        
        arrSmallCar.add("small_car0.png")
        arrSmallCar.add("small_car1.png")
        arrSmallCar.add("small_car2.png")
        arrSmallCar.add("small_car3.png")
        arrSmallCar.add("small_car4.png")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWheels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblName = cell.viewWithTag(10) as! UILabel
        
        let dictWheelCat = arrWheels.object(at: indexPath.row) as! NSDictionary
        
        lblName.text = dictWheelCat.value(forKey: "cat_name") as? String
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dictWheelCat = arrWheels.object(at: indexPath.row) as! NSDictionary
        
        arrSelectedWheelCat = dictWheelCat.value(forKey: "wheels") as! NSMutableArray
        
        collectionWheel.reloadData()
        
        lblWheelCategory.text = dictWheelCat.value(forKey: "cat_name") as? String
        
        hideView(view: wheelCategoryVw)
        showView(view: menuVw)
        showView(view: wheelVw)
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionWheel
        {
            return arrSelectedWheelCat.count
        }
        else
        {
            return arrSmallCar.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collectionWheel
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wheel_cell", for: indexPath)
            
            let imageView = cell.viewWithTag(10) as! UIImageView
            
            let dictWheelCat = arrSelectedWheelCat.object(at: indexPath.row) as! NSDictionary
            
            let strImgName = dictWheelCat.value(forKey: "wheel_name") as? String
            
            imageView.image = UIImage(named: strImgName!)
            
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "car_cell", for: indexPath)
            let imageView = cell.viewWithTag(10) as! UIImageView
            let strCarName = arrSmallCar.object(at: indexPath.row) as? String
            
            imageView.image = UIImage(named: strCarName!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collectionWheel
        {
            let dictWheelCat = arrSelectedWheelCat.object(at: indexPath.row) as! NSDictionary
            
            let strImgName = dictWheelCat.value(forKey: "wheel_name") as? String
            
            imgWheel1.image = UIImage(named: strImgName!)
            
            imgWheel2.image = UIImage(named: strImgName!)
            
            lblWheelName.text = strImgName
            
        }
        else
        {
            let strCarName = arrSmallCar.object(at: indexPath.row) as? String
            carMainImage.image = UIImage(named: strCarName!)
            
            carMainImage.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        carMainImage.image = selectedImage
        carMainImage.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addMovementGesturesToView(bgView: UIView)
    {
        view.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        panGesture.delegate = self
        bgView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        pinchGesture.delegate = self
        bgView.addGestureRecognizer(pinchGesture)
        
        
    }
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer)
    {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    //Issue
    @objc func handlePinchGesture(pinchGesture: UIPinchGestureRecognizer)
    {
        if pinchGesture.state == .began || pinchGesture.state == .changed {
            
            let currentScale = pinchGesture.view?.layer.value(forKeyPath: "transform.scale.x") as! NSNumber
            
            // Variables to adjust the max/min values of zoom
            let minScale = 0.5 as CGFloat
            let maxScale = 1.5 as CGFloat
            let zoomSpeed = 1.0 as CGFloat
            
            var deltaScale = pinchGesture.scale as CGFloat
            
            // You need to translate the zoom to 0 (origin) so that you
            // can multiply a speed factor and then translate back to "zoomSpace" around 1
            deltaScale = ((deltaScale - 1) * zoomSpeed) + 1
            
            
            // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
            //  A deltaScale is ~0.99 for decreasing or ~1.01 for increasing
            //  A deltaScale of 1.0 will maintain the zoom size
            deltaScale = min(deltaScale, CGFloat(maxScale) / CGFloat(truncating: currentScale))
            deltaScale = max(deltaScale, CGFloat(minScale) / CGFloat(truncating: currentScale))
            
            let zoomTransform = pinchGesture.view!.transform.scaledBy(x: deltaScale, y: deltaScale)
            pinchGesture.view?.transform = zoomTransform;
            
            pinchGesture.scale = 1
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVLayerVideoGravity(_ input: AVLayerVideoGravity) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVCaptureSessionPreset(_ input: AVCaptureSession.Preset) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
