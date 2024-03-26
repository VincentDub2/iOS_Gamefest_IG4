//
//  VCard.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//
import SwiftUI

struct VCard: View {
    var title: String
    var subtitle: String
    var caption: String
    var color: Color
    var image: Image
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .frame(maxWidth: 170, alignment: .leading)
                .layoutPriority(1)
            Text(subtitle)
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(caption.uppercased())
                .opacity(0.7)
            Spacer()
            HStack {
                ForEach(Array([4, 5, 6].shuffled().enumerated()), id: \.offset) { index, number in
                    Image("Avatar \(number)")
                        .resizable()
                        .mask(Circle())
                        .frame(width: 44, height: 44)
                        .offset(x: CGFloat(index * -20))
                }
            }
        }
        .foregroundColor(.white)
        .padding(30)
        .frame(width: 320, height: 220)
        .background(.linearGradient(colors: [color.opacity(1), color.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 12)
        .shadow(color: color.opacity(0.3), radius: 2, x: 0, y: 1)
        .overlay(
            image
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
        )
    }
}

struct VCard_Previews: PreviewProvider {
    static var previews: some View {
        VCard(title: "Title", subtitle: "Subtitle", caption: "Caption", color: .blue, image: Image("Avatar 4"))
    }
}
