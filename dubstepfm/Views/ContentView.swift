//
//  ContentView.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/27/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var stream = AudioStream()
    
    @State private var value: Double = 0.0
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Image("dsfm_cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(50)
                Text("title")
                    .colorInvert()
                Spacer()
                HStack {
                    Text(stream.title)
                        .bold()
                        .font(.system(size: 18))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    Spacer()
                }
                
                
                VStack {
                    Slider(value: $value, in: 0...60)
                        .accentColor(.gray)
                    HStack {
                        Text("0:00")
                        Spacer()
                        Text("0:00")
                    }
                }.padding(20)
                
                HStack {
                    Spacer()
                    Button() {
                        print("q")
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                    Spacer()
                    Button() {
                        stream.playSound(sound: "https://archive.dubstep.fm/ARCHIVE_-_2019-03-09_-_JVIZ_Presents_Earthquake_Weather_In_Los_Angeles.mp3")//"http://stream.dubstep.fm/256aac")
                        if stream.isPlaying {
                            stream.pause()
                        } else {
                            stream.play()
                        }
                        
                    } label: {
                        if stream.isPlaying {
                            Image(systemName: "pause.fill")//"play_button")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "play.fill")//"play_button")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                    Button() {
                        print("e")
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
                HStack(spacing: 50) {
                    Button() {} label: {
                        Image(systemName: "airplayaudio")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    Button () {} label: {
                        Image(systemName: "list.bullet.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
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
