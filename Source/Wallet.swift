import SwiftUI

struct LiveWalletView: View {
    @State private var cards: [WalletCard] = sampleCards
    @State private var showingAddCard = false
    @State private var showingMenu = false
    @State private var cardBackgrounds: [Color] = [
        Color(red: 0.20, green: 0.20, blue: 0.40),
        Color(red: 0.30, green: 0.10, blue: 0.30),
        Color(red: 0.15, green: 0.25, blue: 0.35),
        Color(red: 0.25, green: 0.15, blue: 0.25)
    ]
    
    let menuOptions = ["Solicitar Tarjeta", "Oportunidades", "Centro de Seguros", "Ahorros e Inversiones"]
    
    var body: some View {
        ZStack {
            // Fondo color Liverpool (rosa característico)
            Color(red: 0.89, green: 0.0, blue: 0.48)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Encabezado con menú
                HStack {
                    Text("LiveWallet")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                    
                    Spacer()
                    
                    Menu {
                        ForEach(menuOptions, id: \.self) { option in
                            Button(action: {}) {
                                Label(option, systemImage: menuIcon(for: option))
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 40)
                .padding(.bottom, 20)
                
                // Tarjetas con scroll horizontal
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(Array(cards.enumerated()), id: \.element.id) { (index, card) in
                            CardView(card: card, backgroundColor: cardBackgrounds[index % cardBackgrounds.count])
                                .frame(width: 300, height: 190)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                .overlay(
                                    DeleteButton(card: card, cards: $cards)
                                        .offset(x: 120, y: -75)
                                )
                        }
                        
                        AddCardButton(action: { showingAddCard = true })
                            .frame(width: 300, height: 190)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                }
                
                // Sección de Historial
                VStack(alignment: .leading) {
                    Text("Historial de Transacciones")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(transactionHistory, id: \.id) { transaction in
                                TransactionRow(transaction: transaction)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color(red: 0.89, green: 0.0, blue: 0.48).opacity(0.7))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
            }
        }
        .sheet(isPresented: $showingAddCard) {
            AddCardView(cards: $cards, isPresented: $showingAddCard)
        }
    }
    
    private func menuIcon(for option: String) -> String {
        switch option {
        case "Solicitar Tarjeta": return "creditcard.fill"
        case "Oportunidades": return "bolt.fill"
        case "Centro de Seguros": return "shield.fill"
        case "Ahorros e Inversiones": return "chart.line.uptrend.xyaxis"
        default: return "questionmark.circle"
        }
    }
}

// Modelo de transacción y datos de ejemplo
struct Transaction: Identifiable {
    let id = UUID()
    let card: WalletCard
    let amount: Double
    let date: Date
    let merchant: String
    let category: String
}

let transactionHistory = [
    Transaction(card: sampleCards[0], amount: 1250.50, date: Date().addingTimeInterval(-86400), merchant: "Camisa blanca", category: "Ropa"),
    Transaction(card: sampleCards[1], amount: 450.00, date: Date().addingTimeInterval(-172800), merchant: "Comesmeticos ", category: "Comestibles"),
    Transaction(card: sampleCards[0], amount: 3200.75, date: Date().addingTimeInterval(-259200), merchant: "Computadora portatil", category: "Electrónica"),
    Transaction(card: sampleCards[2], amount: 780.30, date: Date().addingTimeInterval(-345600), merchant: "Pizza doble queso", category: "Alimentos"),
    Transaction(card: sampleCards[1], amount: 150.00, date: Date().addingTimeInterval(-432000), merchant: "Reproductor de video", category: "Entretenimiento")
]

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transactionIcon(for: transaction.category))
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.89, green: 0.0, blue: 0.48))
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchant)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(transaction.category)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("-$\(transaction.amount, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func transactionIcon(for category: String) -> String {
        switch category {
        case "Ropa": return "tshirt.fill"
        case "Comestibles": return "cart.fill"
        case "Electrónica": return "laptopcomputer"
        case "Alimentos": return "fork.knife"
        case "Entretenimiento": return "film.fill"
        default: return "creditcard.fill"
        }
    }
}

// Extensión para redondear solo ciertas esquinas
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// (El resto del código de CardView, AddCardButton, AddCardView y modelos permanece igual)

struct CardView: View {
    let card: WalletCard
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            // Fondo de tarjeta con contorno
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // Patrón decorativo sutil
            CardPatternView()
                .opacity(0.1)
                .blendMode(.overlay)
            
            // Contenido de la tarjeta
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: card.type.iconName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(card.type.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Número de tarjeta con efecto de relieve
                Text(card.number.formattedCardNumber())
                    .font(.system(size: 18, design: .monospaced))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("TITULAR")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.name.uppercased())
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("VENCE")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.expiryDate)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(20)
        }
    }
}

struct CardPatternView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let step: CGFloat = 15
                
                for i in stride(from: 0, to: width, by: step) {
                    path.move(to: CGPoint(x: i, y: 0))
                    path.addLine(to: CGPoint(x: i, y: height))
                }
                
                for i in stride(from: 0, to: height, by: step) {
                    path.move(to: CGPoint(x: 0, y: i))
                    path.addLine(to: CGPoint(x: width, y: i))
                }
            }
            .stroke(Color.white, lineWidth: 0.5)
        }
    }
}


    

// (El resto del código de DeleteButton, AddCardButton, FloatingActionButton, AddCardView y modelos permanece igual)

struct DeleteButton: View {
    let card: WalletCard
    @Binding var cards: [WalletCard]
    @State private var showingConfirm = false
    
    var body: some View {
        Button(action: { showingConfirm = true }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
        }
        .alert("¿Eliminar tarjeta?", isPresented: $showingConfirm) {
            Button("Eliminar", role: .destructive) {
                withAnimation {
                    cards.removeAll { $0.id == card.id }
                }
            }
            Button("Cancelar", role: .cancel) {}
        }
    }
}

struct AddCardButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.pink.opacity(0.5), lineWidth: 2)
                    )
                
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.7))
                    Text("Agregar tarjeta")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.89, green: 0.0, blue: 0.48))
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color(red: 0.89, green: 0.0, blue: 0.48).opacity(0.5), radius: 10, x: 0, y: 5)
                .overlay(
                    Circle()
                        .stroke(Color(red: 0.89, green: 0.0, blue: 0.48).opacity(0.3), lineWidth: 2)
                )
        }
    }
}

// (El resto del código de AddCardView, modelos y previews permanece igual)

struct AddCardView: View {
    @Binding var cards: [WalletCard]
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var number = ""
    @State private var expiryDate = ""
    @State private var selectedType: CardType = .visa
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información de la Tarjeta")) {
                    Picker("Tipo", selection: $selectedType) {
                        ForEach(CardType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.iconName)
                                Text(type.rawValue)
                            }
                        }
                    }
                    
                    TextField("Nombre del Titular", text: $name)
                    TextField("Número de Tarjeta", text: $number)
                        .keyboardType(.numberPad)
                    TextField("MM/AA", text: $expiryDate)
                }
                
                Section {
                    Button("Agregar Tarjeta") {
                        let newCard = WalletCard(
                            name: name,
                            number: number,
                            expiryDate: expiryDate,
                            type: selectedType
                        )
                        cards.append(newCard)
                        isPresented = false
                    }
                    .disabled(name.isEmpty || number.isEmpty || expiryDate.isEmpty)
                }
            }
            .navigationTitle("Nueva Tarjeta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        isPresented = false
                    }
                }
            }
        }
        .accentColor(Color(red: 0.89, green: 0.0, blue: 0.48))
    }
}


struct WalletCard: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let expiryDate: String
    let type: CardType
}

enum CardType: String, CaseIterable {
    case visa = "Visa"
    case mastercard = "Mastercard"
    case amex = "American Express"
    case other = "Otra"
    
    var iconName: String {
        switch self {
        case .visa: return "creditcard.fill"
        case .mastercard: return "creditcard.fill"
        case .amex: return "creditcard.fill"
        case .other: return "creditcard"
        }
    }
}

extension String {
    func formattedCardNumber() -> String {
        let chunkSize = 4
        return stride(from: 0, to: self.count, by: chunkSize).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: min(chunkSize, self.count - $0))
            return String(self[start..<end])
        }.joined(separator: " ")
    }
}

// Datos de muestra
let sampleCards = [
    WalletCard(name: "Juan Pérez", number: "4234567812345678", expiryDate: "05/25", type: .visa),
    WalletCard(name: "María García", number: "5555666677778888", expiryDate: "12/23", type: .mastercard),
    WalletCard(name: "Carlos López", number: "378282246310005", expiryDate: "09/24", type: .amex)
]

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        LiveWalletView()
    }
}
