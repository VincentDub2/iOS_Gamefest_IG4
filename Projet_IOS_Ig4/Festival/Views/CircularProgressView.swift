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
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 10.0)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(current) / CGFloat(max))
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
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
