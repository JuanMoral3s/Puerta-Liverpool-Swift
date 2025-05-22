import SwiftUI

private let rewards = [
    Reward(id: 101, title: "2 x 1 en Café Americano", pointsNeeded: 200, description: "2 x 1 en la compra de cualquier café en restaurantes Liverpool", imageReward: Image("reward1"), emoji: "☕", barColor: Color("LiverpoolPink")),
    Reward(id: 102, title: "Descuento del 10% en Addidas", pointsNeeded: 200, description: "Descuento del %10 en cualquier producto de la marca Addidas comprado en tienda", imageReward: Image("reward2"), emoji: "👟", barColor: Color("LiverpoolPink")),
    Reward(id: 103, title: "Cashback del 5% en viajes", pointsNeeded: 200, description: "Cashback equivalente al 5% del costo de tu viaje en cualquier aerolinea para el mes de Mayo", imageReward: Image("reward3"), emoji: "✈️", barColor: Color("LiverpoolPink"))
]


struct RewardsListView: View {
    var body: some View {
        VStack{
            HStack {
                Text("Rewards")
                    .bold()
                    .font(.system(size: 30)) // Aumentar el tamaño de la fuente
                    .foregroundColor(.white)
                
                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                
                Spacer() // Añadir Spacer para separar los íconos y el texto
                
                Text("Tus puntos: 0")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 20))
                    .scaledToFit()
                    .frame(width: 150, height: 30)
                
                Image(systemName: "barcode.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            .padding() // Añadido padding para mejorar el espaciado entre los elementos


            List(rewards, id: \.id) { reward in
                RewardRowView(reward: reward)
            }
        }.background(Color("LiverpoolPink"))
    }
}

#Preview {
    RewardsListView()
}


