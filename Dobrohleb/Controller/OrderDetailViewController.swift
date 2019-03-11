

import UIKit
import GoogleMaps
import Firebase
import FirebaseStorage

class OrderDetailViewController: UIViewController, GMSMapViewDelegate {
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var pointLocation: CLLocation!
    var geocoder = CLGeocoder()
    //var selectedOrderId: String?
    //var ref = Database.database().reference()
    
    public var detailedOrder: Order?
    public var keyOrder : String?
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var typeOfOrderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var customerNumberLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateDistance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func calculateDistance() {
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            
            LocationManager.sharedInstance.getReverseGeoCodedLocation(address: (detailedOrder?.destination)!, completionHandler: { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                
                if placemark == nil {
                    print("Location can't be fetched")
                    return
                }
                
                self.pointLocation = placemark?.location
                
                print((placemark?.location?.coordinate.latitude)!)
                print((placemark?.location?.coordinate.longitude)!)
                //self.detailedOrder?.setDistance(distance: (((self.currentLocation.distance(from: self.pointLocation))/1000)*100).rounded()/100)
                
                self.loadOrder()
                self.loadMap()
                
            })
        } else { print("error")}
    }
    
    private func loadMap() {
        let camera = GMSCameraPosition.camera(withLatitude: self.pointLocation.coordinate.latitude, longitude: pointLocation.coordinate.longitude, zoom: 6.0)
        let marker = GMSMarker(position: pointLocation.coordinate)
        marker.map = mapView
        mapView?.animate(to: camera)
    }
    private func loadOrder(){
        //cityLabel.text = "Адрес: \(detailedOrder?.destination ?? "Город")"
        //priceLabel.text = "ФИО:\(detailedOrder?.price ?? "Name")"
        //typeOfOrderLabel.text = "Дополнительно: \(detailedOrder?.typeOfOder?.getType.lowercased() ?? "груз")"
        //weightLabel.text = "Дата последней доставки: \(detailedOrder?.weightOfCargo ?? "")"
        //dimensionsLabel.text = "Возраст: \(detailedOrder?.distance ?? "")"
        //customerNumberLabel.text = "Номер телефона: \(detailedOrder?.customerNumber ?? 0000)"
        //distanceLabel.text = "Пожелания: \(detailedOrder?.dimensions?.height ?? "") > \(detailedOrder?.dimensions?.length ?? "") > \(detailedOrder?.dimensions?.width ?? "") > \(detailedOrder?.dimensions?.height ?? "")"
        cityLabel.text = "\(detailedOrder?.destination ?? "Город")"
        priceLabel.text = "\(detailedOrder?.price ?? "Name")"
        typeOfOrderLabel.text = "\(detailedOrder?.typeOfOder?.getType.lowercased() ?? "груз")"
        weightLabel.text = "\(detailedOrder?.weightOfCargo ?? "")"
        dimensionsLabel.text = "\(detailedOrder?.distance ?? "")"
        customerNumberLabel.text = "\(detailedOrder?.customerNumber ?? 0000)"
        distanceLabel.text = "\(detailedOrder?.dimensions?.height ?? "")"
        let storage = Storage.storage()
        let islandRef = storage.reference(forURL: detailedOrder?.photourl ?? "")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 10 * 256 * 256) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let imagedw = UIImage(data: data!)
                self.img?.image = imagedw
            }
        }
 
        
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any!) {
        //ref.child("orders").child(selectedOrderId ?? "").updateChildValues(["weightOfCargo" : "In progress"])
        if (segue.identifier == "goToMap") {
            let svc = segue.destination as! MapViewController
            svc.detailedOrder = detailedOrder
        }
    }
    
}
