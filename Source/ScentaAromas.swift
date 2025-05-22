import SwiftUI

struct Compras: View {
    @EnvironmentObject var cart: ShoppingCartOO
    let imagenes = ["p1", "p3", "p2"]
    @State private var indiceActual = 0
    let timer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    
    @State private var iconoselec = "house.fill"
    let iconos = ["house.fill", "sparkle.magnifyingglass", "creditcard.fill", "aqi.medium", "person.fill"]
    let nombres = ["inicio", "Explorar", "Crédito y ahorro", "Servicios", "Mi cuenta"]
    
    // Variables de estado para navegación
    @State private var showProfile = false
    @State private var showCamera = false
    @State private var showLiveWallet = false
    @State private var showRewards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo rosa con iconos
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.89, green: 0.0, blue: 0.48))
                        .frame(width: 500, height: 210)
                        .overlay(
                            VStack {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                                    .offset(x: 60, y: 100)
                                
                                Image(systemName: "cart.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 30))
                                    .offset(x: 110, y: 70)
                                
                                Button(action: {
                                    showRewards = true
                                }) {
                                    Image(systemName: "sparkles")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 30))
                                }
                                .offset(x: 160, y: 32)
                            }
                        )
                        .offset(y: -420)
                }
                
                // Carrusel de imágenes
                HStack {
                    ZStack {
                        TabView(selection: $indiceActual) {
                            ForEach(0..<imagenes.count, id: \.self) { index in
                                Image(imagenes[index])
                                    .resizable()
                                    .scaledToFill()
                                    .tag(index)
                                    .frame(width: 402, height: 500)
                                    .cornerRadius(1)
                                    .clipped()
                            }
                        }
                        .offset(y: -115)
                        .frame(height: 400)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .onReceive(timer) { _ in
                            withAnimation {
                                indiceActual = (indiceActual + 1) % imagenes.count
                            }
                        }
                        
                        // Texto "Para ti en tienda"
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 250, height: 40)
                                .offset(y: -280)
                            
                            Text("Para ti en tienda")
                                .font(.system(size: 22))
                                .foregroundColor(Color(red: 0.89, green: 0.0, blue: 0.48))
                                .offset(y: -280)
                        }
                    }
                }
                
                // Contenido principal
                ZStack {
                    // Encabezado
                    Text("¡Hola, Isaac!")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.white)
                        .position(x: 150, y: 35)
                    
                    Text("Puntos: 0")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .position(x: 413, y: 65)
                    
                    // Botón de escanear
                    Button(action: {
                        showCamera = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.89, green: 0.0, blue: 0.48).opacity(0.8))
                                .frame(width: 300, height: 90)
                            
                            HStack {
                                Image(systemName: "barcode.viewfinder")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 40))
                                
                                Text("Escanea tu producto")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .position(x: 250, y: 550)
                    
                    // Sección inferior
                    Text("Productos vistos recientemente")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .position(x: 200, y: 630)
                    
                    // Barra de navegación inferior
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.89, green: 0.0, blue: 0.48), lineWidth: 1)
                        .frame(width: 450, height: 90)
                        .position(x: 250, y: 780)
                    
                    // Iconos de navegación
                    HStack(spacing: -15) {
                        ForEach(0..<iconos.count, id: \.self) { index in
                            let icono = iconos[index]
                            let nombre = nombres[index]
                            
                            Button(action: {
                                iconoselec = icono
                                switch icono {
                                case "person.fill":
                                    showProfile = true
                                case "creditcard.fill":
                                    showLiveWallet = true
                                default:
                                    break
                                }
                            }) {
                                VStack {
                                    Image(systemName: icono)
                                        .font(.system(size: 26))
                                        .foregroundColor(iconoselec == icono ? Color(red: 0.89, green: 0.0, blue: 0.48) : .gray)
                                    Text(nombre)
                                        .font(.caption)
                                        .foregroundColor(iconoselec == icono ? Color(red: 0.89, green: 0.0, blue: 0.48) : .gray)
                                }
                                .padding()
                                .background(
                                    Circle()
                                        .fill(iconoselec == icono ? Color.red.opacity(0.2) : Color.clear)
                                )
                            }
                        }
                    }
                    .padding()
                    .position(x: 250, y: 770)
                }
            }
            
            .navigationDestination(isPresented: $showCamera) {
                CameraView()
            }
            .navigationDestination(isPresented: $showLiveWallet) {
                LiveWalletView()
            }
            .navigationDestination(isPresented: $showProfile) {
                
            }
            .navigationDestination(isPresented: $showRewards) {
                RewardsListView()
            }
        }
    }
}

#Preview {
    Compras()
}

