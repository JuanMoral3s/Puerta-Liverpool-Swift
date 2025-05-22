import SwiftUI

struct productDO: Identifiable {
    let id = UUID()
    var name : String
    var marca: String
    var cantidad: Int = 0
    var description : String
    var price : Double
    var discount : Double
    var image : Image
    var department: String
}



