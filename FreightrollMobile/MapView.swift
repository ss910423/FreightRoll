//
//  MapView.swift
//  FreightrollMobile
//
//  Created by Douglas Drouillard on 3/26/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

//
//  MapCell.swift
//  FreightrollMobile
//
//  Created by Brian Dittmer on 10/14/17.
//  Copyright © 2017 Freightroll. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewDelegate: class {
    func annotationSelect(view: MKAnnotationView)
}

class MapView: UIView {
    
    var mapView =  MKMapView()
    weak var delegate: MapViewDelegate?


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mapView)
        self.mapView.delegate = self
        
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addHeading(point: MKPointAnnotation, deadhead: Int) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        point.title = "pickup"
        self.mapView.addAnnotation(point)
        if deadhead != -1 {
            self.mapView.removeOverlays(self.mapView.overlays)
            let region = MKCircle(center: point.coordinate, radius: Double(deadhead) * 1609.34)
            self.mapView.add(region)
        }
    }
    
    func configure(with shipments: [Shipment]) -> MapView {
        var count = 0
        for shipment in shipments {
            guard let pickup = shipment.pickup else { continue }
            pickup.title = "\(count)"
            self.mapView.addAnnotation(pickup)
            count += 1
        }
        
        //self.mapView.showsUserLocation = true
        
        return self
    }
    
    func configure(for shipment: Shipment) -> MapView {
        guard let pickup = shipment.pickup, let dropoff = shipment.dropoff else { return self }
        
        self.mapView.addAnnotations([pickup, dropoff])
        
        //self.mapView.showsUserLocation = true
        
        return self
    }
    
   
    

}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKPointAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            let circle = UIImage(named: "centerPoint")
            view.image = circle
            return view
        }
        else{
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            return view
            
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.delegate?.annotationSelect(view: view)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.fillColor = UIColor(red:0.29, green:0.71, blue:0.91, alpha:0.15)
        return circle
    }
}



