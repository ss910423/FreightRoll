//
//  ImagePickerModel.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/20/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import Photos

class ImagePickerModel: NSObject{
 
    private var imagePicker: UIImagePickerController!
    private var imageAlbum: UIImagePickerController!
    var latestPhotoAssetsFetched: PHFetchResult<PHAsset>? = nil
    var shipment: Shipment?
    var imageOverlay: ImagePickerOverlayView?
    var recentImage: UIImage?

    private weak var presentingViewController: UIViewController?
    
    init( viewController: UIViewController, shipment: Shipment) {
        super.init()
        self.imageOverlay = Bundle.main.loadNibNamed("ImagePickerOverlayView", owner: self, options: nil)![0] as? ImagePickerOverlayView
        self.imageOverlay?.delegate = self
        self.shipment = shipment
        presentingViewController = viewController
    }
    
    func showImagePicker() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.denied {
            alertAccessDenied(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        }
        else if (authStatus == AVAuthorizationStatus.notDetermined) {
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for permission.
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                        self.cameraAccessGranted()
                    }
                }
            )
        } else {
            // Allowed access to camera, go ahead and present the UIImagePickerController.
            //showImagePicker(sourceType: UIImagePickerControllerSourceType.camera)
            cameraAccessGranted()
        }
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
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
    

    func cameraAccessGranted(){
        DispatchQueue.main.async {
            self.imageOverlay?.libraryImageButton.setImage(UIImage(named: "camera_gray"), for: .normal)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera;
            self.imagePicker.allowsEditing = false
            
            
            
            
            if recentImage == nil{
                print("recentimage is nil")
                PHPhotoLibrary.requestAuthorization({ (authStatus) in

                    if authStatus == PHAuthorizationStatus.authorized{
                        self.latestPhotoAssetsFetched = self.fetchLatestPhotos(forCount: 1)
                        if self.latestPhotoAssetsFetched!.count > 0{
                            if let asset = self.latestPhotoAssetsFetched?[0]{
                                print("requesting image")

                                PHImageManager.default().requestImage(for: asset,
                                                                      targetSize: CGSize(width:40, height:40),
                                                                      contentMode: .aspectFill,
                                                                      options: nil) { (image, _) in
                                                                        self.recentImage = image
                                                                        DispatchQueue.main.async {
                                                                            self.imageOverlay?.libraryImageButton.setImage(self.recentImage, for: .normal)

                                                                        }
                                                                        

                                }
                            }
                        }
                    }
                })
                
            }else{
                imageOverlay?.libraryImageButton.setImage(self.recentImage, for: .normal)
            }
           
            imageOverlay?.frame = (self.imagePicker.cameraOverlayView?.frame)!
            self.imagePicker.cameraOverlayView = imageOverlay
            self.imagePicker.showsCameraControls = false
            self.imagePicker.view.backgroundColor = UIColor.white
            
            let cameraAspectRatio = 4.0 / 3.0
            let imageWidth = (Double(UIScreen.main.bounds.width) * cameraAspectRatio)
            let scale = ((Double(UIScreen.main.bounds.height - 124) / imageWidth) * 10.0) / 10.0
            let translation = CGAffineTransform(translationX: CGFloat(0), y: CGFloat(50));
            let scaleTrans = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            self.imagePicker.cameraViewTransform = translation.concatenating(scaleTrans)

            
            presentingViewController?.present(self.imagePicker, animated: true, completion: nil)

        }
    }
    
    func fetchLatestPhotos(forCount count: Int?) -> PHFetchResult<PHAsset> {
        
        // Create fetch options.
        let options = PHFetchOptions()
        
        // If count limit is specified.
        if let count = count { options.fetchLimit = count }
        
        // Add sortDescriptor so the lastest photos will be returned.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        // Fetch the photos.
        return PHAsset.fetchAssets(with: .image, options: options)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerModel: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let controller: ViewPictureViewController = UIStoryboard(storyboard: .app).instantiateViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.makeKeyAndVisible()
        
        controller.hidesBottomBarWhenPushed = true
        controller.newImage = image
        controller.shipment = shipment
        controller.recentImage = recentImage
        
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        presentingViewController?.navigationItem.backBarButtonItem = backItem
        presentingViewController?.navigationController?.pushViewController(controller, animated: true)
        //self.dismiss(animated: true, completion: nil)
        
    }
    
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        //onImagePicked(nil)
    }
}

extension ImagePickerModel: ImagePickerOverlayDelegate{
    func changeFlash(flashMode: UIImagePickerControllerCameraFlashMode) {
        self.imagePicker.cameraFlashMode = flashMode
    }
    
    func showLibrary() {
        self.imageAlbum = UIImagePickerController()
        self.imageAlbum.delegate = self
        self.imageAlbum.sourceType = .photoLibrary;
        self.imageAlbum.allowsEditing = false
        self.imagePicker.present(self.imageAlbum, animated: true, completion: nil)
    }
    
    func didCancel(){
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func takePhoto(){
         self.imagePicker.takePicture()
    }
    func showAlert(title: String, message: String) {
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
        self.imagePicker.present(alert, animated: true, completion: nil)
    }
}
