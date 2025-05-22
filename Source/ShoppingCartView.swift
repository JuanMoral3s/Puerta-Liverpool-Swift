import SwiftUI

struct ShoppingCartView: View {
    @EnvironmentObject  var cart : ShoppingCartOO
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "LiverpoolPink")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("🛍️ Tus productos seleccionados")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color("LiverpoolPink"))
            
            Text("Revisa lo que más te gustó")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        ForEach(cart.products){ product in
            if product.cantidad > 0 {
                NavigationLink{
                    ProductDetailView(product:product)
                        .navigationTitle(product.name)
                        .environmentObject(cart)
                } label: {
                    ShoppingCartRow(product: product)
                }
            }
        }
    }
}

#Preview {
    ShoppingCartView()
}


