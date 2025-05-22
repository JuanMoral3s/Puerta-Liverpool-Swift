import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var cameraModel = CameraViewModel()
    @State private var scanningLinePosition: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            Group {
                Circle()
                    .fill(pinkGradient)
                    .frame(width: 400, height: 400)
                    .offset(x: 100, y: -520)
                
                Circle()
                    .fill(pinkGradient)
                    .frame(width: 400, height: 400)
                    .offset(x: 5, y: -130)
                
                Circle()
                    .fill(pinkGradient)
                    .frame(width: 400, height: 400)
                    .offset(x: -130, y: -400)
                
                Circle()
                    .fill(pinkGradient)
                    .frame(width: 400, height: 400)
                    .offset(x: 100, y: -400)
            }
            
            
            RoundedRectangle(cornerRadius: 50)
                .fill(Color(red: 0.89, green: 0.0, blue: 0.48))
                .ignoresSafeArea()
                .frame(width: 420, height: 650)
                .offset(y: 100)
            
         
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Escáner de Producto")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .offset(y: 25)
                    
                
                    ZStack {
                        
                        ZStack {
                            CameraPreview(session: cameraModel.session)
                                .frame(width: 350, height: 200)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            
                         
                            Rectangle()
                                .fill(Color.green.opacity(0.6))
                                .frame(width: 350, height: 3)
                                .offset(y: scanningLinePosition)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                                            scanningLinePosition = 100
                                        }
                                    }
                                    scanningLinePosition = -100
                                }
                            
                            // Barcode pattern effect
                            ForEach(0..<20, id: \.self) { i in
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: CGFloat.random(in: 10...30), height: 1)
                                    .offset(x: CGFloat.random(in: -150...150),
                                           y: CGFloat.random(in: -90...90))
                            }
                        }
                        .frame(width: 350, height: 200)
                        
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 180)
                            .foregroundColor(.white.opacity(0.3))
                            .offset(y: 1)
                    }
                    .offset(y: 40)
                    
                    
                    Button(action:  {
                        
                    }) {
                        Text("Capturar")
                            .font(.headline)
                            .foregroundColor(.pink)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: Color(red: 0.89, green: 0.0, blue: 0.48).opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 70)
                }
                
                Spacer()
            }
        }
        .onAppear {
            cameraModel.configure()
        }
    }
    
    private var pinkGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.89, green: 0.0, blue: 0.48),
                Color(red: 0.89, green: 0.0, blue: 0.48).opacity(0.5),
                .white
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}


    
    private var pinkGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.89, green: 0.0, blue: 0.48),
                Color(red: 0.89, green: 0.0, blue: 0.48).opacity(0.5),
                .white
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }


struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 200))
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        previewLayer.cornerRadius = 10
        view.layer.addSublayer(previewLayer)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private let queue = DispatchQueue(label: "camera.queue")
    
    func configure() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("Could not configure camera.")
            return
        }
        
        session.addInput(input)
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        queue.async {
            self.session.startRunning()
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let data = photo.fileDataRepresentation(),
           let _ = UIImage(data: data) {
            print("Photo captured successfully")
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
