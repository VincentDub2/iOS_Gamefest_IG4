//
//  ContentView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    @State private var showNextView = false
    var images : [String] = ["house","pencil.and.list.clipboard","calendar","message","person"]
    @State var selected = "house"
    @Namespace private var namespace
    @ObservedObject private var sessionManager = SessionManager.shared

    var window: UIWindow?
    var body: some View {
        ZStack{
            if !showNextView {
                           // Background Image with Enter Button
                           BackgroundView(showNextView: $showNextView)
            } else {
                if let _ = sessionManager.user {
                    // If user is connected, show the main view
                    if selected == "person" {
                        ProfileView()
                            .padding(.bottom, 120)
                    }else if selected == "calendar" {
                        CalendarKitView()
                            .padding(.bottom, 120)
                    }else if selected == "pencil.and.list.clipboard" {
                        HousingView()
                            .padding(.bottom, 120)
                    }else if selected == "message" {
                        ForumView()
                            .padding(.bottom, 120)
                    }else{
                        HouseView()
                            .padding(.bottom, 120)
                    }
                        navBar
                } else {
                    LoginView()
                }
            }
        }.edgesIgnoringSafeArea(.bottom)
        
    }
}


struct Wave: Shape {
    func path(in rect: CGRect) -> Path {
        Path{path in
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

extension ContentView{
    private var navBar: some View {
        VStack{
            Spacer()
            HStack(){
                HStack{
                    ForEach(images, id: \.self) { iconName in
                        if selected == iconName {
                            ZStack{
                                Wave()
                                    .fill(.background)
                                    .frame(width: 80, height: 20)
                                    //.border(.orange, width: 1)
                                    .scaleEffect(2)
                                    .offset(y:-10)
                                    .matchedGeometryEffect(id: "let1", in: namespace)
                                Image(systemName: selected)
                                    .font(.title3.bold())
                                    .foregroundColor(.primary)
                                    .padding(.horizontal,40)
                                    .offset(y:-30)
                                    .matchedGeometryEffect(id: "let2", in: namespace)
                                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                                
                            }
                        }else {
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
                .padding(.bottom,30)
                .frame(maxWidth: .infinity)
                .background(
                    .black
                )

            }
        }
    }
}
#Preview {
    ContentView().preferredColorScheme(.light)
}
