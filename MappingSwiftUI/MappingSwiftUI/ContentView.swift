//
//  ContentView.swift
//  MappingSwiftUI
//
//  Created by Javier Calderon Jr. on 1/2/20.
//  Copyright © 2020 RockefellerMagic. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        mapView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct mapView: UIViewRepresentable {
    
    func makeCoordinator() -> mapView.Coordinator {
        return mapView.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<mapView>) -> MKMapView {
        
        let map = MKMapView()
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: 34.075539, longitude: -118.239990)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: 37.418980, longitude: -122.082375)
        
        let region =  MKCoordinateRegion(center: sourceCoordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        
        let sourcePin = MKPointAnnotation()
        sourcePin.coordinate = sourceCoordinate
        sourcePin.title = "Source"
        map.addAnnotation(sourcePin)
        
        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destinationCoordinate
        destinationPin.title = "Destination"
        map.addAnnotation(destinationPin)
        
        map.region = region
        map.delegate = context.coordinator
        
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        
        let directions = MKDirections(request: req)
        
        directions.calculate { (direct, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let polyline = direct?.routes.first?.polyline
            map.addOverlay(polyline!)
        map.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
        }
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<mapView>) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapview: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .orange
            render.lineWidth = 3
            
            return render
        }
    }
}
