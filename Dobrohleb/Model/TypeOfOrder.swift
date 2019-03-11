

import Foundation

enum OrderType: String{
    case cargo
    case documents
    case tyreDisk
    case packages
    case pallets
    
    
    public var getType: String {
        switch self {
        case .cargo: return "Cargo"
        case .documents: return "Documents"
        case .tyreDisk: return "Tyre or Disks"
        case .packages: return "Package"
        case .pallets: return "Pallets"
        }
    }
}
