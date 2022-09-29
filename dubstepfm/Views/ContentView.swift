//
//  ContentView.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/27/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Image("dsfm_cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(50)
                Text("title")
                    .colorInvert()
                Spacer()
                
                HStack {
                    Button("Back") {
                        print("q")
                    }
                    Button("Play/pause") {
                        print("w")
                    }.padding(30)
                    Button("Forward") {
                        print("e")
                    }
                }

                Spacer()
            }
        }
        
//        .background(Color.black)
//        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
