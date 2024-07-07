//
//  VideoPlayerWithTranscription.swift
//  JestVids
//
//  Created by Vardhan Chopada on 7/7/24.
//

import SwiftUI
import AVKit
import SceneKit


struct VideoPlayerWithTranscription: View {
    let videoName: String
    @State private var player: AVPlayer?
    @State private var currentTime: Double = 0
    @State private var transcription: String = ""
    @State private var transcriptionData: [TranscriptionItem] = []
    @State private var isCC: Bool = false
    @State private var scene: SCNScene?
    @State private var lightNode: SCNNode?
    @State private var isLightOn = true
    
    var body: some View {
        ZStack {
            if let scene = scene {
                SceneView(
                    scene: scene
                )
                .ignoresSafeArea(.all)
                
                
                ZStack {
                    VideoPlayer(player: player)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 162, height: 155)
                        .aspectRatio(contentMode: .fill)
                        .offset(x: -13,y: 65)
                        .opacity(isLightOn ? 1 : 0.5)
                    
                    if isCC {
                        Text(transcription)
                            .frame(width: 140, height: 50)
                            .offset(x: -10,y: 90)
                            .foregroundColor(.white)
                            .font(.caption2)
                            .transition(.opacity)
                            .animation(.easeInOut, value: 0.3)
                    }
                }
            }
            
            
            RemoteControlsView(isLightOn: $isLightOn, player: $player, lightNode: $lightNode, isCC: $isCC)
                .offset(y: 300)
        }
        .onAppear {
            loadVideo()
            loadModel()
            loadTranscriptionData()
        }
    }
    
    
    private func loadModel() {
        guard let url = Bundle.main.url(forResource: "LivingRoom", withExtension: "usdz") else {
            print("Failed to find USDZ file")
            return
        }
        
        do {
            let scene = try SCNScene(url: url, options: [.checkConsistency: true])
            let rotation = simd_quatf(angle: -.pi/2, axis: SIMD3<Float>(0, 1, 0))
            scene.rootNode.simdOrientation = rotation
            
            scene.rootNode.position.y = 20
            scene.rootNode.position.z = 140
            
            let light = SCNLight()
            light.type = .ambient
            light.intensity = 300
            
            let newLightNode = SCNNode()
            newLightNode.light = light
            newLightNode.position = SCNVector3(0, 50, 0)
            scene.rootNode.addChildNode(newLightNode)
            
            lightNode = newLightNode
            
            self.scene = scene
        } catch {
            print("Failed to load USDZ file: \(error)")
        }
    }
    
    private func loadVideo() {
        guard let path = Bundle.main.path(forResource: videoName, ofType: "mov") else {
            print("Video file not found")
            return
        }
        let videoURL = URL(fileURLWithPath: path)
        player = AVPlayer(url: videoURL)
        player?.play()
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
            currentTime = time.seconds
            updateTranscription()
        }
    }
    
    private func loadTranscriptionData() {
        guard let url = Bundle.main.url(forResource: "transcript", withExtension: "json") else {
            print("Transcript JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            transcriptionData = try JSONDecoder().decode([TranscriptionItem].self, from: data)
        } catch {
            print("Error loading transcript data: \(error)")
        }
    }
    
    private func updateTranscription() {
        if let currentItem = transcriptionData.first(where: { $0.startTime <= currentTime && $0.endTime > currentTime }) {
            transcription = currentItem.text
        } else {
            transcription = ""
        }
    }
}
