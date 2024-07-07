//
//  RemoteButton.swift
//  JestVids
//
//  Created by Vardhan Chopada on 7/7/24.
//

import SwiftUI

struct RemoteButton: View {
    let systemName: String
    let action: () -> Void
    let color: Color
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                            .shadow(color: .white.opacity(0.3), radius: 1, x: 0, y: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(color)
            }
        }
    }
}
