//
//  VideoBackGroundView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 25/03/2024.
//
import Foundation
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
