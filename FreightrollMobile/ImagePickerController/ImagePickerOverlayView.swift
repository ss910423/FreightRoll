//
//  ImagePickerOverlayView.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/20/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerOverlayDelegate: class{
    func didCancel()
    func changeFlash(flashMode: UIImagePickerControllerCameraFlashMode)
    func takePhoto()
    func showLibrary()
    func showAlert(title: String, message: String)
}

class ImagePickerOverlayView: UIView{
    
    enum Flash {
        case auto
        case on
        case off
    }

    @IBOutlet weak var flashButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var libraryImageButton: UIButton!
    @IBOutlet weak var innerPhotoButton: UIButton!
    @IBOutlet weak var outerPhotoButton: UIButton!
    
    weak var delegate: ImagePickerOverlayDelegate?
    var flash = Flash.auto
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerPhotoButton.layer.cornerRadius = 25
        innerPhotoButton.layer.masksToBounds = true
        innerPhotoButton.addTarget(self, action:#selector(self.takePhotoPressed), for: .touchUpInside)
        
        outerPhotoButton.layer.cornerRadius = 29
        outerPhotoButton.layer.masksToBounds = true
        outerPhotoButton.layer.borderColor = UIColor.app_blue.cgColor
        outerPhotoButton.layer.borderWidth = 2.0
        outerPhotoButton.addTarget(self, action:#selector(self.takePhotoPressed), for: .touchUpInside)
 
    }
    
    @IBAction func libraryImagePressed(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization({ (authStatus) in
            if authStatus == PHAuthorizationStatus.denied {
                // Denied access to camera, alert the user.
                // The user has previously denied access. Remind the user that we need camera access to be useful.
                self.delegate?.showAlert(title: "Unable to access the Photo Library", message: "To enable access, go to Settings > Privacy > Photos and turn on Photo access for this app.")
            }
            else {
                self.delegate?.showLibrary()
            }
        })
        
    }
    func alertAccessDenied(title: String?, message: String?){
        // Denied access to camera, alert the user.
        // The user has previously denied access. Remind the user that we need camera access to be useful.
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            // Take the user to Settings app to possibly change permission.
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    // Finished opening URL
                })
            }
        })
        alert.addAction(settingsAction)
    }
    
    @objc func takePhotoPressed ( button: Any? ){
        print("pressed")

        delegate?.takePhoto()
    }
   
    @IBAction func flashPressed(_ sender: Any) {
        switch(flash){
        case .auto:
            delegate?.changeFlash(flashMode: .on)
            flashButtonOutlet.image = UIImage(named: "flashOn")
            
            flash = .on
        case .on:
            delegate?.changeFlash(flashMode: .off)
            flashButtonOutlet.image = UIImage(named: "flashOff")
            
            flash = .off
        case .off:
            delegate?.changeFlash(flashMode: .auto)
            flashButtonOutlet.image = UIImage(named: "flashAuto")
            
            flash = .auto
        }
    }
    @IBAction func cancelPressed(_ sender: Any) {
        print("cancel")

        delegate?.didCancel()
    }
    
}
