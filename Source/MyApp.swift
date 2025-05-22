import SwiftUI

@main
struct MyApp: App {
    @StateObject var cart = ShoppingCartOO()
    var body: some Scene {
        WindowGroup {
            Compras()
                .environmentObject(cart)
        }
    }
}
