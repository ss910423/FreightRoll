//
//  UploadProofOfDeliveryViewController.swift
//  FreightrollMobile
//
//  Created by Freight Roll on 1/25/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit

class UploadProofOfDeliveryViewController: UIViewController,UINavigationControllerDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var liveShipmentSelect: UIPickerView!
    @IBOutlet weak var imageTake: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    var liveShipments: [Shipment] = AppDelegate.sharedAppDelegate().appCurrentState.liveShipments
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //liveShipmentSelect.dataSource = self
        //liveShipmentSelect.delegate = self
        
        saveButton.isEnabled = false
    }
    /*
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            saveButton.isEnabled = true
        }
    }

    @IBAction func saveAndUpload(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func displayUploadSuccessDialog(){
        let ac = UIAlertController(title: "Uploaded!", message: "Your proof of delivery image has been uploaded.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        saveButton.isEnabled = false
    }
    
    func displayUploadFailedDialog(){
        let ac = UIAlertController(title: "Error!", message: "Your proof of delivery image has not been uploaded. Please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        saveButton.isEnabled = false
    }
    */
}
/*
extension UploadProofOfDeliveryViewController: GetPresignDelegate {
    
    func getPresignSuccess(presign: Presign) {
        getAwsAPI().postToS3(presign: presign, image: imageTake.image!, delegate: self)
    }
}

extension UploadProofOfDeliveryViewController: PostToS3Delegate {
    
    func postToS3Success(presign: Presign, fileSize: Int) {
        let selectedShipment = self.liveShipmentSelect.selectedRow(inComponent: 0)
        getAPI().postProofOfDelivery(presign: presign, shipment: self.liveShipments[selectedShipment], fileSize: fileSize, delegate: self)
    }
}

extension UploadProofOfDeliveryViewController: PostProofOfDeliveryDelegate {
    
    func postProofOfDeliverySuccess() {
        displayUploadSuccessDialog()
    }
    
    func postProofOfDeliveryFailed(){
        displayUploadFailedDialog()
    }
}

extension UploadProofOfDeliveryViewController: UIImagePickerControllerDelegate {
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            getAPI().getPresign(delegate: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageTake.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}

extension UploadProofOfDeliveryViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.liveShipments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.liveShipments[row].stringDisplay()
    }
}
*/
