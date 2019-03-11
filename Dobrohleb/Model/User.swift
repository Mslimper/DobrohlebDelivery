

import Foundation
import Firebase

class User: NSObject {
    var email : String?
    var firstName : String?
    var lastName : String?
    var city : String?
    var telNumber : Int?
    var licenseNumber : String?
    var carNumber : String?
    var insuranceTerm : Date?
    
    var ref: DatabaseReference?

//    init(email: String?, firstName: String?, lastName : String?, city : String?, telNumber : Int?) {
//        //self.id = id
//        self.email = email
//        self.firstName = firstName
//        self.lastName = lastName
//        self.city = city
//        self.telNumber = telNumber
//    }
    
}
