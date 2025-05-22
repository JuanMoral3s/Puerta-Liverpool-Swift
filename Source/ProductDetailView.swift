import SwiftUI

struct ProductDetailView: View {
    let product: productDO
    @State private var animate_image = false
    @State private var isExpanded = false
    @State private var cantidad = 1
    @State private var tallaSeleccionada: String = "M"
    let tallas = ["S", "M", "G", "XG"]
    
    var body: some View {
        let precio_descuento = product.price - (product.price * product.discount)
        
        VStack(spacing: 20) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Imagen del artículo
                    HStack {
                        Spacer()
                        product.image
                            .resizable()
                            .scaledToFit()
                            .offset(x: animate_image ? 0 : -600, y: 0)
                            .animation(.default, value: animate_image)
                        Spacer()
                    }
                    .frame(height: 200)
                    
                    // Metadatos del artículo
                    Text(product.name)
                        .font(.largeTitle)
                        .foregroundColor(Color("LiverpoolPink"))
                        .bold()
                    
                    Text(product.marca.uppercased())
                        .font(.title)
                        .bold()
                    
                    // Precio individual
                    if product.discount > 0 {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("$\(product.price, specifier: "%.2f")")
                                    .strikethrough()
                                Text("- \(product.discount * 100, specifier: "%.0f")%")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                            Text("$\(precio_descuento, specifier: "%.2f")")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.system(size: 24))
                            .bold()
                    }
                    
                    // Selector de talla
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Talla:")
                            .font(.headline)
                        HStack(spacing: 12) {
                            ForEach(tallas, id: \.self) { talla in
                                Button(action: {
                                    tallaSeleccionada = talla
                                }) {
                                    Text(talla)
                                        .font(.headline)
                                        .frame(width: 50, height: 40)
                                        .background(
                                            tallaSeleccionada == talla
                                            ? Color("LiverpoolPink")
                                            : Color(.systemGray6)
                                        )
                                        .foregroundColor(tallaSeleccionada == talla ? .white : .black)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    
                    // Selector de cantidad
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cantidad:")
                            .font(.headline)
                        HStack(spacing: 20) {
                            Button("-") {
                                if cantidad > 1 {
                                    cantidad -= 1
                                }
                            }
                            
                            
                            Text("\(cantidad)")
                                .frame(minWidth: 30)
                            
                            Button("+") {
                                if cantidad < 9 {
                                    cantidad += 1
                                }
                            }
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("LiverpoolPink"))
                    }
                    
                    // Departamento
                    Text("Departamento: \(product.department)")
                        .font(.body)
                        .bold()
                    
                    // Descripción desplegable
                    DisclosureGroup("Descripción del producto", isExpanded: $isExpanded) {
                        Text(product.description)
                            .padding(.top, 5)
                            .font(.body)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .animation(.easeInOut, value: isExpanded)
                    
                    Spacer()
                }
                .padding(.bottom, 150) // Espacio para el total
            }
            
            // Sección de total y botón de compra
            VStack {
                Divider()
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        if product.discount > 0 {
                            Text("Total: ")
                                .font(.headline)
                                .bold()
                            HStack {
                                Text("$\(Double(cantidad) * product.price, specifier: "%.2f")")
                                    .strikethrough()
                                Text("- \(product.discount * 100, specifier: "%.0f")%")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                            Text("$\(Double(cantidad) * precio_descuento, specifier: "%.2f")")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.red)
                        } else {
                            VStack(alignment: .leading) {
                                Text("Total: ")
                                    .font(.headline)
                                    .bold()
                                Text("$\(Double(cantidad) * product.price, specifier: "%.2f")")
                                    .font(.system(size: 24))
                                    .bold()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("+5 puntos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        NavigationLink {
                            ShoppingCartView()
                        } label: {
                            Text("Agregar al carrito")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 180, height: 50)
                                .background(Color("LiverpoolPink"))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
        .padding()
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            animate_image = true
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProduct = productDO(
            name: "Taza Glass",
            marca: "Nespresso",
            cantidad: 3,
            description: "Mantiene tus bebidas frías o calientes por más de 12 horas. Ideal para llevar al gimnasio, trabajo o viajes.",
            price: 599.99,
            discount: 0.20, // 20% de descuento
            image: Image(systemName: "cup.and.saucer.fill"),
            department: "Hogar"
        )

        NavigationStack {
            ProductDetailView(product: sampleProduct)
        }
    }
}
