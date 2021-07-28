//
//  CreateReminderButton.swift
//  PooPal
//
//  Created by Tom  on 7/27/21.
//

import SwiftUI


struct CreateReminderButton: View {
    @State var isAtMaxScale = false
    
    private let animation = Animation.easeOut(duration: 1.2).repeatForever(autoreverses: true)
    
    private let maxScale: CGFloat = 2
    
    var body: some View {
        ZStack {
            Color("Taupe")
            VStack {
                Text("Tap to PooPal")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.bottom)
                
                ZStack {
                    Circle()
                    .foregroundColor(Color("White"))
                    .opacity(0.4)
                    .frame(width: 200, height: 200)
                    
                    Image("Poop")
                        .resizable()
                        .frame(width: 64, height: 64)
                    }
                    .padding()
                    .scaleEffect(isAtMaxScale ? 1 : 0.95)
                    .onAppear {
                        withAnimation(self.animation, {
                            self.isAtMaxScale.toggle()
                    })
        //            Button(action: {
        //                showingSheet.toggle()
        //            })  {
        //                Image("Poop")
        //                    .frame(width: 60, height: 60)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct CreateReminderButton_Previews: PreviewProvider {
    static var previews: some View {
        CreateReminderButton()
    }
}
