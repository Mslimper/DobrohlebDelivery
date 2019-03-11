

import UIKit
import MapKit
import CoreLocation
import MessageUI
import Firebase
import Foundation



class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    public var detailedOrder: Order?
    
    //    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locManager = CLLocationManager()
    
    var destinationLocation: CLLocation!
    let currentDate = Date()
    var selectedOrderId: String?
    var ref = Database.database().reference()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        getCoordinates()
        loadLabels()
        loadMap()
    }
    
    
    private func loadMap() {
        LocationManager.sharedInstance.getReverseGeoCodedLocation(address: (detailedOrder?.destination)!, completionHandler: { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            
            if placemark == nil {
                print("Location can't be fetched")
                return
            }
            
            self.destinationLocation = placemark?.location
            
            print(self.destinationLocation.coordinate)
            
            self.getRoute()
        })
    }
    
    private func getRoute() {
        map.delegate = self
        map.showsScale = true
        map.showsPointsOfInterest = true
        map.showsUserLocation = true
        
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
        }
        
        let sourceCoordinates = locManager.location?.coordinate
        let destCoordinates = CLLocationCoordinate2DMake(destinationLocation.coordinate.latitude, destinationLocation.coordinate.longitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        print ("Координаты", sourceCoordinates)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
    
    
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            
            guard let response = response else {
                if let error = error {
                    print("wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.map.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        })
    }
    
    private func loadLabels() {
        cityLabel.text = "Адрес: \(detailedOrder?.destination ?? "city")"
        // distanceLabel.text = "Расстояние: \(detailedOrder?.distance ?? 111)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func report(_ sender: UIButton) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    
        
    
    //@IBAction func mapReport(_ sender: UIButton) {
        //let mailComposeViewController = configureMailController()
        //if MFMailComposeViewController.canSendMail() {
            //self.present(mailComposeViewController, animated: true, completion: nil)
       // } else {
         //   showMailError()
      //  }
  //  }
    

    
    @IBAction func handleDelieveryGesture(_ sender: Any) {
        
        let date = Foundation.Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "MSK")
        
        selectedOrderId = (detailedOrder?.idOrder)
        ref.child("orders").child(selectedOrderId ?? "").updateChildValues(["weightOfCargo" : "\(dateFormatter.string(from: date))"])
        
        
        if (sender as AnyObject).state == UIGestureRecognizerState.began {
            let alertController = UIAlertController(title: nil, message:
                "Подтвердите доставку", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default,handler: {
                (UIAlertAction)in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "goToProfile") as! ProfileViewController
                self.present(nextViewController, animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.purple
        renderer.lineWidth = 7.0
        
        return renderer
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["svetlimir@yandex.ru"])
        mailComposerVC.setSubject("Возникла ошибка при работе с приложением")
        mailComposerVC.setMessageBody("Опишите свою ошибку", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
