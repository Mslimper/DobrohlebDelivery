

import Foundation

class Dimensions: NSObject {
    var length : String!
    var width : String!
    var height : String!
    
    
    init(height: String, length: String, width: String) {
        self.height = height
        self.length = length
        self.width = width
    }
}
