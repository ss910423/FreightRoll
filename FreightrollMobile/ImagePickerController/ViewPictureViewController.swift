//
//  ViewPictureViewController.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/10/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import NVActivityIndicatorView

class ViewPictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var sucessImage: UIImageView!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var animView: UIView!
    @IBOutlet weak var anim: NVActivityIndicatorView!
    @IBOutlet weak var uploadOutlet: UIButton!
    @IBOutlet weak var discardOutlet: UIButton!
    var newImage: UIImage?
    var recentImage: UIImage?
    var imagePicker: UIImagePickerController!
    var imagePickerModel: ImagePickerModel?
    var imageAlbum: UIImagePickerController!
    var latestPhotoAssetsFetched: PHFetchResult<PHAsset>? = nil
    var flash = Flash.auto
    var didShow = false
    var shipment: Shipment?
    
    enum Flash {
        case auto
        case on
        case off
    }
 
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func configureUI(){
        animView.isHidden = true
        imageView.image = newImage
        uploadOutlet.setImage(UIImage(named: "upload"), for: .normal)
        uploadOutlet.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)
        uploadOutlet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
        
        discardOutlet.setImage(UIImage(named: "discard"), for: .normal)
        discardOutlet.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)
        discardOutlet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
    }
    
    
    @objc func cancelButton( button: Any? ){
        self.dismiss(animated: true, completion: nil)
        
    }
  
    
    @objc func openPhotoAlbum(button: Any?){
        self.imageAlbum = UIImagePickerController()
        self.imageAlbum.delegate = self
        self.imageAlbum.sourceType = .photoLibrary;
        self.imageAlbum.allowsEditing = false
        self.imagePicker.present(self.imageAlbum, animated: true, completion: nil)
    }
    
    @IBAction func discardTapped(_ sender: Any) {
        imagePickerModel = ImagePickerModel( viewController: self, shipment: shipment!)
        imagePickerModel?.showImagePicker()
    }
    @objc func imagePickerController(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            getAPI().getPresign(delegate: self)
        }
    }
    @IBAction func uploadTapped(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(imagePickerController(_:didFinishSavingWithError:contextInfo:)), nil)
        uploadOutlet.isEnabled = false
        animView.isHidden = false
        anim.startAnimating()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadOutlet.alpha = 0
            self.discardOutlet.alpha = 0
            self.animView.alpha = 1

            
        }, completion: {
            (value: Bool) in
            self.uploadOutlet.isHidden = true
            self.discardOutlet.isHidden = true
        })
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

    func displayUploadSuccessDialog(){
        uploadOutlet.isEnabled = false
        uploadLabel.text = "Successfully uploaded"
        anim.alpha = 0
        sucessImage.alpha = 1
        
        let ac = UIAlertController(title: "Uploaded!", message: "Your proof of delivery image has been uploaded.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popToRootViewController(animated: true)

        }))
        present(ac, animated: true)  
    }
    
    func displayUploadFailedDialog(){
        let ac = UIAlertController(title: "Error!", message: "Your proof of delivery image has not been uploaded. Please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
        uploadOutlet.isEnabled = true
        self.uploadOutlet.isHidden = false
        self.discardOutlet.isHidden = false
        anim.startAnimating()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadOutlet.alpha = 1
            self.discardOutlet.alpha = 1
            self.animView.alpha = 0
            
            
        }, completion: {
            (value: Bool) in
           
            self.animView.isHidden = true
        })
    }
}

extension ViewPictureViewController: GetPresignDelegate {
    
    func getPresignSuccess(presign: Presign) {
        getAwsAPI().postToS3(presign: presign, image: imageView.image!, delegate: self)
    }
}

extension ViewPictureViewController: PostToS3Delegate {
    
    func postToS3Success(presign: Presign, fileSize: Int) {
        getAPI().postProofOfDelivery(presign: presign, shipment: self.shipment!, fileSize: fileSize, delegate: self)
    }
}

extension ViewPictureViewController: PostProofOfDeliveryDelegate {
    
    func postProofOfDeliverySuccess() {
        displayUploadSuccessDialog()
    }
    
    func postProofOfDeliveryFailed(){
        displayUploadFailedDialog()
    }
}

