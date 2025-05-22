import SwiftUI

struct PerfilView: View {
    @Binding var sesionActiva: Bool // para actualizar el estado de la sesión
    
    var body: some View {
        VStack {
            Text("Perfil")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                sesionActiva = false // cerrar sesión
            }) {
                Text("Cerrar sesión")
                    .font(.title2)
                    .foregroundColor(.red)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Mi Perfil")
    }
}

#Preview {
    PerfilView(sesionActiva: .constant(true))
}

