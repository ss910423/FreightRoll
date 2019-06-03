//
//  BOLViewController.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/14/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit

class BOLViewController: UITableViewController {

    static func instance(shipment: Shipment) -> BOLViewController {
        let vc = BOLViewController(style: .plain)
        vc.shipment = shipment

        return vc
    }

    enum Cell {
        case available(isAvailable: Bool)
        case takePhoto(label: String)
        case photo
        case submit
    }

    fileprivate var image: UIImage?
    fileprivate var cells: [Cell] = []

    var shipment: Shipment!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "AvailabilityCell", bundle: Bundle.main), forCellReuseIdentifier: "AvailabilityCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: Bundle.main), forCellReuseIdentifier: "ButtonCell")

        self.cells = setupCells(shipment: self.shipment, image: self.image)
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    fileprivate func setupCells(shipment: Shipment, image: UIImage?) -> [Cell] {
        var cells: [Cell] = []
        
        cells.append(.available(isAvailable: AppDelegate.sharedAppDelegate().appCurrentState.userAvailable))

        if let image = image {
            cells.append(.photo)
            cells.append(.takePhoto(label: "Retake"))
            cells.append(.submit)
        } else {
            cells.append(.takePhoto(label: "Take Photo"))
        }

        return cells
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .available(let isAvailable):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailabilityCell") as? AvailabilityCell else {
                break
            }
            cell.availableSwitch.isOn = isAvailable

            return cell

        case .takePhoto(let label):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? ButtonCell else {
                break
            }

            return cell.configure(title: label, callback: self.takePhoto, uploadCall: self.takePhoto)

        case .photo:
            return UITableViewCell(style: .default, reuseIdentifier: nil)

        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? ButtonCell else {
                break
            }

            return cell.configure(title: "Submit", callback: self.submit, uploadCall: self.submit)
        }

        fatalError()
    }

    func takePhoto(_ button: UIButton) {

    }

    func submit(_ button: UIButton) {
        getAPI().delivered(shipment: self.shipment, delegate: self)
    }
}

extension BOLViewController: DeliveredShipmentDelegate {
    func deliveredShipmentSuccess(shipment: Shipment) {
        self.showAlert(title: "Finished!", message: nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
