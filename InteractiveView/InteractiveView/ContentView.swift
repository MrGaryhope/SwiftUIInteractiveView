//
//  ContentView.swift
//  InteractiveView
//
//  Created by Егор Максимов on 02.03.2022.
//

import SwiftUI

struct MyView : View {
    @Binding var degree : Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).stroke(LinearGradient(colors: [.blue,.red], startPoint: .topLeading, endPoint: .bottomTrailing),lineWidth: 10)

            RoundedRectangle(cornerRadius: 15).fill(.white)

            
            RoundedRectangle(cornerRadius: 15).fill(LinearGradient(colors: [.blue.opacity(0.95),.red.opacity(0.95)], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Text("Hello world").font(.title).bold()
                .foregroundStyle(.thinMaterial)
            
        }.hueRotation(Angle(degrees: degree))
    }
}

struct InteractiveView : View {
    @State var degree = 0.0
    @State var xAxis : CGFloat = 0
    @State var yAxis : CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            let gesture = DragGesture()
                .onChanged { value in
                    degree = 0
                    //bottom right
                    if value.location.x > geo.frame(in: .local).midX &&
                        value.location.y > geo.frame(in: .local).midY {
                        xAxis = -1
                        yAxis = 1
                        degree = 20
                    }
                    //bottom left
                    else  if value.location.x < geo.frame(in: .local).midX &&
                                value.location.y > geo.frame(in: .local).midY {
                        xAxis = -1
                        yAxis = -1
                        degree = 20
                    }
                    //top left
                    else  if value.location.x < geo.frame(in: .local).midX &&
                                value.location.y < geo.frame(in: .local).midY {
                        xAxis = 1
                        yAxis = -1
                        degree = 20
                    }
                    // top right
                    else  if value.location.x > geo.frame(in: .local).midX &&
                                value.location.y < geo.frame(in: .local).midY {
                        xAxis = 1
                        yAxis = 1
                        degree = 20
                    }
                }.onEnded { value in
                    degree = 0
                    xAxis = 0
                    yAxis = 0
                }
            
            MyView(degree: $degree)
                .rotation3DEffect(Angle(degrees: degree), axis: (x: xAxis, y: yAxis, z: 0))
                .gesture(gesture)
                .animation(.spring(dampingFraction: 0.4), value: degree)
                .animation(.spring(dampingFraction: 0.4), value: xAxis)
                .animation(.spring(dampingFraction: 0.4), value: yAxis)
        }.frame(width: 300, height: 300)

    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.7),.purple.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            Color.black.opacity(0.8).ignoresSafeArea()
            InteractiveView()
        }
    }
}
