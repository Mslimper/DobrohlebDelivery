

import Foundation

class DeliveredInfo: NSObject {
    var idUser : String?
    var actualDistance : Double?
    var startDate : Date?
    var endDate : Date?
    
    public func setUser(id: String?) {
        self.idUser = id
    }
}
