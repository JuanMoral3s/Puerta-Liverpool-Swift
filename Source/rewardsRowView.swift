import SwiftUI
import CoreImage.CIFilterBuiltins

struct RewardRowView: View {
    var reward: Reward
    @State private var isExpanded = false // Controla si la recompensa está expandida

    var body: some View {
        VStack {
            // Barra con imagen parcial
            HStack {
                reward.imageReward
                    .resizable()
                    .scaledToFill() // Asegura que la imagen llene completamente el espacio disponible
                    .frame(height: isExpanded ? 400 : 200) // Aumenta la altura cuando se expanda, por ejemplo 400
                    .clipped() // Para evitar que la imagen se corte fuera de los bordes
                    .cornerRadius(10)
                    .padding([.top, .leading, .trailing])
                    .overlay(
                        VStack {
                            Spacer()
                            Text(reward.title)
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .padding(10)
                        }
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isExpanded.toggle() // Cambiar el estado de expansión
                        }
                    }
                
                Spacer()
            }
            .background(Color.white.opacity(1)) // Fondo oscuro para la imagen
            .cornerRadius(10)
            
            // Información expandida
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    // Mostrar los puntos necesarios
                    Text("Puntos necesarios: \(reward.pointsNeeded)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("LiverpoolPink").opacity(0.7))
                        .cornerRadius(10)

                    // Descripción de la recompensa
                    Text(reward.description)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("LiverpoolPink").opacity(0.7))
                        .cornerRadius(10)

                    // Código QR (si tienes alguna URL asociada con la recompensa)
                    if let qrCode = generateQRCode(from: "https://www.example.com/\(reward.id)") {
                        Image(uiImage: qrCode)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(20)
                            .background(Color("LiverpoolPink").opacity(0.7))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .padding()
                .transition(.move(edge: .bottom)) // Animación de entrada para el contenido expandido
            }
        }
        .padding(.bottom, 10)
    }

    // Función para generar el código QR a partir de una cadena
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        
        // Usar el nombre correcto del filtro "CIQRCodeGenerator"
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        filter.setValue(string.data(using: .utf8), forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}

struct RewardRowViewPreviews: PreviewProvider {
    static var previews: some View {
        RewardRowView(reward: Reward(id: 101, title: "2 x 1 en café americano.", pointsNeeded: 200, description: "2 X 1 en la compra de cualquier café al comprar en mostrador", imageReward: Image("reward1"), emoji: "☕", barColor: .blue))
    }
}

