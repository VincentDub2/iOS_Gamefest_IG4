//
//  ContentView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import SwiftUI
import AVFoundation

struct VideoBackgroundView: UIViewRepresentable {
    var player: AVPlayer
    
    func makeCoordinator() -> Coordinator {
        Coordinator(player: player)
    }
    
    init(videoName: String, videoType: String) {
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
            fatalError("Video file not found.")
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player.isMuted = true
        player.actionAtItemEnd = .none
        player.play()
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        context.coordinator.startPlayer(player: player)
        context.coordinator.adjustPlayerLayerFrame(view: view)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    class Coordinator: NSObject {
        var player: AVPlayer
        
        init(player: AVPlayer) {
            self.player = player
        }
        
        func startPlayer(player: AVPlayer) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
        }
        
        @objc func playerItemDidReachEnd(notification: Notification) {
            if let playerItem = notification.object as? AVPlayerItem {
                playerItem.seek(to: .zero, completionHandler: nil)
                player.play()
            }
        }
        func adjustPlayerLayerFrame(view: UIView) {
            DispatchQueue.main.async {
                guard let layer = view.layer.sublayers?.first as? AVPlayerLayer else { return }
                layer.frame = view.bounds
            }
        }
    }
}


struct ContentView: View {
    @State private var showNextView = false
    @ObservedObject private var sessionManager = SessionManager.shared
    var images: [String] = ["house", "magnifyingglass", "plus", "person", "loupe"]
    @State var selected = "house"
    @Namespace private var namespace

    var body: some View {
        ZStack {
            if !showNextView {
                // Background Image with Enter Button
                BackgroundView(showNextView: $showNextView)
            } else {
                //Switch Content Here
                if selected == "person" {
                    if sessionManager.isLoggedIn() {
                        ProfileView()
                    } else {
                        LoginView()
                    }
                } else if selected == "plus" {
                    CalendarKitView()
                } else if selected == "magnifyingglass" {
                    CalendarView()
                } else if selected == "loupe" {
                    CalendarContainerView()
                }

                navBar
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    private var navBar: some View {
        VStack {
            Spacer()
            HStack {
                HStack {
                    ForEach(images, id: \.self) { iconName in
                        if selected == iconName {
                            ZStack {
                                Wave()
                                    .fill(.background)
                                    .frame(width: 80, height: 20)
                                    //.border(.orange, width: 1)
                                    .scaleEffect(2)
                                    .offset(y: -10)
                                    .matchedGeometryEffect(id: "let1", in: namespace)
                                Image(systemName: selected)
                                    .font(.title3.bold())
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 40)
                                    .offset(y: -30)
                                    .matchedGeometryEffect(id: "let2", in: namespace)
                                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                            }
                        } else {
                            Image(systemName: iconName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding(20)
                                .onTapGesture {
                                    withAnimation {
                                        self.selected = iconName
                                    }
                                }
                        }
                    }
                }
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .background(
                    .black
                )

            }
        }
    }
}

struct BackgroundView: View {
    @Binding var showNextView: Bool

        var body: some View {
            ZStack {
                VideoBackgroundView(videoName: "backgroundVideo", videoType: "mp4") // Assurez-vous que le fichier vidéo est dans votre bundle
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                // Opacity of the background image

            VStack {
                Spacer()
               
                // Button to enter
                Button(action: {
                    self.showNextView = true
                }) {
                    Text("C'est parti !")
                        .font(.custom("Pacifico", size: 24)) // Remplacez "Pacifico" par le nom de votre police calligraphique
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .shadow(radius: 10)
                }
                .padding(.bottom, 100)
               
            }
        }
    }
}

struct Wave: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addQuadCurve(to: CGPoint(x: rect.width * 0.4, y: rect.height * 0.7),
                              control: CGPoint(x: rect.width * 0.2, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.7),
                              control: CGPoint(x: rect.midX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                              control: CGPoint(x: rect.width * 0.8, y: rect.minY))
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))

        }

    }
}

#Preview {
    ContentView().preferredColorScheme(.light)
}
