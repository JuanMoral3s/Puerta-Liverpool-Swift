import SwiftUI

class ShoppingCartOO : ObservableObject{
    
    @Published var products = [
        productDO(name: "Perfume Hombre", marca: "Gucci", cantidad: 2, description: "Fragancia masculina 200ml", price: 100.0, discount: 0.0, image: Image("producto1"), department: "Perfumeria"),
        productDO(name: "Bufanda", marca: "Santory", cantidad: 10,description: "Bufanda de Dama azul", price: 200.0, discount: 0.0, image: Image("producto2"),department: "Damas" ),
        productDO(name: "Gorra Los Angeles", marca: "New Era", cantidad: 0, description: "Gorra de los angeles genial de color azul marino", price: 100.0, discount: 0.0, image: Image("producto3"),department: "Caballeros"),
        productDO(name: "Balon de Basquetbol",marca: "Willson", cantidad: 15, description: "Balón de basquetbol profesional Wilson", price: 100.0, discount: 0.5, image: Image("producto4"),department: "Deportes"),
        productDO(name: "Reloj", marca: "Citizen", cantidad: 1, description: "Reloj Citizen Gris Elegante", price: 5000.0, discount: 0.3, image: Image("producto5"), department: "Relojería"),
    ]
    
}

