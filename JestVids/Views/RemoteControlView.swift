//
//  RemoteControlView.swift
//  JestVids
//
//  Created by Vardhan Chopada on 7/7/24.
//

import SwiftUI
import AVKit
import SceneKit

struct RemoteControlsView: View {
    @Binding var isLightOn: Bool
    @State var isMuted: Bool = false
    @State var isPlaying: Bool = true
    @Binding var player: AVPlayer?
    @Binding var lightNode: SCNNode?
    @Binding var isCC: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            RemoteButton(systemName: "lightbulb", action: togglePower, color: isLightOn ? .yellow : .gray)
            
            RemoteButton(systemName: "captions.bubble", action: toggleCC, color: isCC ? .yellow : .gray)
            RemoteButton(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill", action: toggleMute, color: .gray)
            
            RemoteButton(systemName: isPlaying ? "pause.fill" : "play.fill", action: togglePlayPause, color: .blue)
            
            
            RemoteButton(systemName: "gobackward.5", action: { seek(by: -5) }, color: .gray)
            RemoteButton(systemName: "goforward.5", action: { seek(by: 5) }, color: .gray)
            
            RemoteButton(systemName: "ev.plug.dc.nacs.fill", action: openExternalLink, color: .red)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
    }
    
    private func togglePower() {
        guard let lightNode = lightNode else { return }
        
        if isLightOn {
            lightNode.light?.intensity = 100
        } else {
            lightNode.light?.intensity = 300
        }
        
        isLightOn.toggle()
    }
    
    
    private func toggleCC() {
        isCC.toggle()
    }
    
    private func toggleMute() {
        isMuted.toggle()
        player?.isMuted = isMuted
    }
    
    private func togglePlayPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    private func seek(by seconds: Double) {
        if let currentTime = player?.currentTime() {
            let newTime = CMTimeGetSeconds(currentTime) + seconds
            player?.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
        }
    }
    
    private func openExternalLink() {
            if let url = URL(string: "https://youtu.be/xvFZjo5PgG0?si=pVNrLjW2j0uug6hA") {
                UIApplication.shared.open(url)
            }
        }
}

