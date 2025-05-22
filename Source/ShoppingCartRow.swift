import SwiftUI

struct ShoppingCartRow: View {
    var product : productDO
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading) {
                product.image
                    .resizable()
                    .scaledToFit()
            }.frame(width: 100)
                
            VStack(alignment: .leading) {
                Text(product.name)
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                    .bold()
                
                
                if product.discount > 0 {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("$\(product.price, specifier: "%.2f")")
                                .font(.system(size: 23))
                                .foregroundColor(.black)
                                .bold()
                                .strikethrough()
                            Text("- \(product.discount * 100, specifier: "%.0f")%")
                                .font(.system(size: 24))
                                .foregroundColor(.green)
                        }
                        Text("$\(product.price - product.discount * 100, specifier: "%.2f")")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundColor(Color("LiverpoolPink"))
                    }
                } else {
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(Color("LiverpoolPink"))
                }
            }
            Spacer()
            ZStack(alignment: .trailing) {
                Text("\(product.cantidad)")
                    .frame(width: 30, height: 30)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .offset(x:-20, y:0)
            }
        }
        .frame(height: 100)
        //.border(.red)
        
        
    }
}

struct ShippingCartRow_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartRow(product: productDO(
                name: "Taza Glass",
                marca: "Nespresso",
                cantidad: 3,
                description: "Mantiene tus bebidas frías o calientes por más de 12 horas. Ideal para llevar al gimnasio, trabajo o viajes.",
                price: 599.99,
                discount: 0.20, // 20% de descuento
                image: Image(systemName: "cup.and.saucer.fill"),
                department: "Hogar"
            )
        )
    }
}


