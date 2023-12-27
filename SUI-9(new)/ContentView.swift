//
//  ContentView.swift
//  SUI-9(new)
//
//  Created by  Pavel Nepogodin on 27.12.23.
//

import SwiftUI

struct ContentView: View {
    @State var position: CGSize = .zero
    
    func setPositionWithAnimation(_ position: CGSize) {
        withAnimation(.interpolatingSpring(
            stiffness: 150,
            damping: 15
        )) {
            self.position = position
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.radialGradient(
                    colors: [.yellow, .orange],
                    center: .center,
                    startRadius: 50,
                    endRadius: 100
                ))
                .mask {
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(
                            min: 0.5,
                            color: .black
                        ))
                        context.addFilter(.blur(radius: 30))
                        context.drawLayer { ctx in
                            for index in [1,2] {
                                if let shape = context.resolveSymbol(
                                    id: index
                                ) {
                                    ctx.draw(shape, at: CGPoint(
                                        x: size.width / 2,
                                        y: size.height / 2
                                    ))
                                }
                            }
                        }
                    } symbols: {
                        Circle()
                            .frame(width: 100, height: 100)
                            .tag(1)
                        
                        Circle()
                            .frame(width: 100, height: 100)
                            .offset(position)
                            .tag(2)
                    }
                }
            Image(systemName: "cloud.sun.rain.fill")
                .foregroundStyle(Color.white)
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 30))
                .frame(width: 100, height: 100)
                .offset(position)
        }
        .background(.black)
        .ignoresSafeArea()
        .gesture(
            DragGesture()
                .onChanged({ value in
                    setPositionWithAnimation(value.translation)
                }).onEnded({ _ in
                    setPositionWithAnimation(.zero)
                })
        )
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

