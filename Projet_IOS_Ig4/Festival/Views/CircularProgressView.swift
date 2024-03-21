//
//  CircularProgressView.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 19/03/2024.
//

import Foundation
import SwiftUI

struct CircularProgressView: View {
    let current: Int
    let max: Int
    
    var body: some View {
        let color: Color
        if current >= max {
            color = .red
        } else if current > max / 2 {
            color = .orange
        } else if current >= max / 3 {
            color = Color(hex: "#ffd500")
        } else {
            color = .green
        }
        
        return VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10.0)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(current) / CGFloat(max))
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color) // Set color based on logic
                    .rotationEffect(Angle(degrees: -90))
                
                Text("\(current)/\(max)")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .frame(width: 50, height: 50)
            .padding(.bottom, 5)
        }
    }
}

extension Color {
    // Extension to create Color from hex string
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
}
