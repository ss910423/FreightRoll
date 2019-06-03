//
//  AcceptShipMapCell.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/21/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import UIKit
import MapKit

class AcceptShipMapCell: UITableViewCell {
    
    static let cellIdentifier = "acceptShipMapCell"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var gradientView: UIView! {
        didSet {
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: gradientView.bounds.width, height: CGFloat(accountViewMapHeight))
            gradient.colors = [UIColor.white.withAlphaComponent(0.0).cgColor,
                               UIColor.white.withAlphaComponent(1.0).cgColor]
            gradient.locations = [0.0, 0.5]
            gradientView.layer.insertSublayer(gradient, at: 0)
            gradientView.backgroundColor = UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addHeading(point: MKAnnotation, deadhead: Int) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(point)
        
        if deadhead != -1 {
            self.mapView.removeOverlays(self.mapView.overlays)
            
            let region = MKCircle(center: point.coordinate, radius: Double(deadhead) * 1609.34)
            self.mapView.add(region)
            
            
        }
    }
    
    func configure(with shipments: [Shipment]) -> AcceptShipMapCell {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        var count = 0
        for shipment in shipments {
            guard let pickup = shipment.pickup else { continue }
            pickup.title = "\(count)"
            self.mapView.addAnnotation(pickup)
            count += 1
        }
        
        let annotations = self.mapView.annotations
        let source = MKPlacemark(coordinate: annotations[0].coordinate, addressDictionary: [
            "" : ""
            ]
        )
        let sourceMapItem = MKMapItem(placemark: source)
        let destination = MKPlacemark(coordinate: annotations[1].coordinate, addressDictionary: [
            "" : ""
            ]
        )
        let distMapItem = MKMapItem(placemark: destination)
        let request = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = distMapItem
        request.transportType = .automobile
        let direction = MKDirections(request: request)
        direction.calculate{ (response, error) in
            
            if error == nil {
                for route: MKRoute in (response?.routes)! {
                    self.mapView.add(route.polyline, level: .aboveRoads)
                }
            }
        }
        
        return self
    }
    
    func configure(for shipment: Shipment) -> AcceptShipMapCell {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        guard let pickup = shipment.pickup, let dropoff = shipment.dropoff else { return self }
        pickup.title = "0"
        dropoff.title = "1"
        self.mapView.addAnnotations([pickup, dropoff])
        
        let source = MKPlacemark(coordinate: pickup.coordinate, addressDictionary: [
            "" : ""
            ]
        )
        let sourceMapItem = MKMapItem(placemark: source)
        let destination = MKPlacemark(coordinate: dropoff.coordinate, addressDictionary: [
            "" : ""
            ]
        )
        let distMapItem = MKMapItem(placemark: destination)
        let request = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = distMapItem
        request.transportType = .automobile
        let direction = MKDirections(request: request)
        direction.calculate{ (response, error) in
            
            if error == nil {
                for route: MKRoute in (response?.routes)! {
                    self.mapView.add(route.polyline, level: .aboveRoads)
                }
            }
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        
        
        return self
    }
    
}

extension MapCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKPointAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            let circle = UIImage(named: "centerPoint")
            view.image = circle
            if #available(iOS 11.0, *) {
                view.displayPriority = .required
            } else {
                // Fallback on earlier versions
            }
            return view
        }
        else{
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            if annotation is MKUserLocation {
                let view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
                let circle = UIImage(named: "centerPoint")
                view.image = circle
                return view
            }
            if annotation.title! == "0"{
                view.pinTintColor = .red
            } else {
                view.pinTintColor = .green
            }
            if #available(iOS 11.0, *) {
                view.displayPriority = .required
            } else {
                // Fallback on earlier versions
            }
            return view
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(hex: "0x2490c4")
            renderer.lineWidth = 3.0
            return renderer
        }
        
        let circle = MKCircleRenderer(overlay: overlay)
        circle.fillColor = UIColor(red:0.29, green:0.71, blue:0.91, alpha:0.15)
        return circle
    }
    
    
    
}
