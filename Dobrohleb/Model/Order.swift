

import Foundation
import Firebase
import CoreLocation

class Order: NSObject {
    
    private var ref: DatabaseReference?
    
    var idOrder : String?
    var price: String?
    var destination : String?
    var distance : String?
    var typeOfOder: OrderType?
    var weightOfCargo : String?
    var dimensions : Dimensions?
    var customerNumber : Int?
    var deliveredInfo : DeliveredInfo?
    var status : StatusType?
    var photourl: String?

    
    public func updateOrder(status: StatusType?) {
        self.status = status
    }
    
    public func setDistance(distance: String?) {
        self.distance = distance
    }
    
    init?(destination: String, price: String, idOrder: String, typeOfOder: String, weightOfCargo: String, dimensions: Dimensions, customerNumber: String, distance: String, photourl: String) {
        self.ref = nil
        self.idOrder = idOrder
        self.price = price
        self.destination = destination
        self.typeOfOder = OrderType(rawValue: typeOfOder)
        self.weightOfCargo = weightOfCargo
        self.dimensions = dimensions
        self.customerNumber = Int(customerNumber)
        self.distance = distance
        self.photourl = photourl
    }
    
    static func order(from snapshot: DataSnapshot) -> Order? {
        let orderDict = snapshot.value as? [String : AnyObject] ?? [:]
        guard let destination = orderDict["pointOfDeparture"] as? String,
            let price =  orderDict["price"] as? String,
            let idOrder = snapshot.key as? String,
            let typeOfOder = orderDict["typeOfOrder"] as? String,
            let weightOfCargo = orderDict["weightOfCargo"] as? String,
            let length = orderDict["length"] as? String,
            let width = orderDict["width"] as? String,
            let height = orderDict["height"] as? String,
            let customerNumber = orderDict["customerNumber"] as? String,
            let distance = orderDict["distance"] as? String,
            let photourl = orderDict["photourl"] as? String
            else { return nil }
        let dimensions = Dimensions(height: height, length: length, width: width)
        let order = Order(destination: destination, price: price, idOrder: idOrder, typeOfOder: typeOfOder, weightOfCargo: weightOfCargo, dimensions: dimensions, customerNumber: customerNumber, distance: distance, photourl: photourl)
        
        return order
    }
    
}
