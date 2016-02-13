//
//  ICOLocalizaMapaViewController.swift
//  App_Mapas_LugaresFavoritos
//
//  Created by User on 13/2/16.
//  Copyright © 2016 iCologic. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ICOLocalizaMapaViewController: UIViewController {
    
    //MARK: - VARIABLES LOCALES
    let locationManager = CLLocationManager()
    
    
    
    
    
    //MARK: - IBOUTLET
    
    @IBOutlet weak var myMapMK: MKMapView!
    
    
    
    
    //MARK: - IBACTION
    
    
    
    //MARK: - CYCLE LIFE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Establecemos el estilo de visualizacion del mapa
        myMapMK.mapType = MKMapType.Satellite

        //Colocamos un gesto del tipo LongPress y lo añadimos a la vista del mapa
        let myGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "pressedViewMap:")
        myGestureRecognizer.minimumPressDuration = 2
        myMapMK.addGestureRecognizer(myGestureRecognizer)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UTILS
    
    func pressedViewMap(gestureRecognizer: UIGestureRecognizer){
        //para no tener mas chinchetas en el mismo sitio debemos limitar el gesto reconocido
        //debemos preguntar al gesto a traves de un metodo llamado state y debemos esteblecer el estilo de actuacion, solo cuando levantamos el dedo pasados 2 segundos es cunado el gesto reconoce la chincheta
        
        if gestureRecognizer.state == UIGestureRecognizerState.Recognized{
            
            let touchPoint = gestureRecognizer.locationInView(myMapMK)
            let newCoordinate  = myMapMK.convertPoint(touchPoint, toCoordinateFromView: myMapMK)
            
            
            //Aqui queremos usando al geocodificacion inversa que en el titulo de la chincheta nos aparezca el nombre de la calle o la informacion que yo mas quiera
            //La clase CLGeocoder necesita un objeto del tipo CLLocation por lo que no nosvales newCoordinate
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            //Creamos la instancia del CLGeocoder
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, Error) -> Void in
                
                //creamos un titulo de momento vacio ya le meteremos la info que nos devuelva el Geocoder
                var newTitle = ""
                var newSubTitle = ""
                
                //lo primero es resolver si ha podido obtener la informacion
                if let placemarkData = placemarks?.first{
                    
                    if placemarkData.thoroughfare != nil{
                        
                        newTitle += "\(placemarkData.thoroughfare!)"
                        
                    }
                    
                    if placemarkData.subThoroughfare != nil{
                        
                        newSubTitle += " \(placemarkData.subThoroughfare!)"
                    }
                    
                    if newTitle == "" {
                        
                        newTitle = "Hupps creo que no existe"
                    }
                    
                    if newSubTitle == ""{
                        newSubTitle = "Punto añadido el \(NSDate())"
                    }
                    
                    //creamos una anotacion
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = newTitle
                    annotation.subtitle = newSubTitle
                    //Añadimos la chincheta al mapa
                    self.myMapMK.addAnnotation(annotation)
                    
                }
            })
            
            
            /*//creamos una anotacion
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            annotation.title = "Nueva Localizacion"
            annotation.subtitle = "Aqui estamos de nuevo"
            //Añadimos la chincheta al mapa
            myMapMK.addAnnotation(annotation)*/
        }
        
    }

}



extension ICOLocalizaMapaViewController : CLLocationManagerDelegate{
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations.first!)
        
        //Centramos el mapa en la posicion del usuario
        if let userLocation = locations.first{
            
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            
            self.myMapMK.setRegion(region, animated: true)
            
            
        }
    }
    
    
}
