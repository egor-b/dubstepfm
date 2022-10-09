//
//  ContentView.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/27/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var stream = AudioStream()
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Image("dsfm_cover")
                    .resizable()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                    .padding(50)
                    .shadow(color: colorScheme == .dark ? .gray : .black, radius: 15)
                Spacer()
                
                HStack {
                    Text(stream.title)
                        .bold()
                        .font(.system(size: 15))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                    Spacer()
                }
                
                HStack {
                    Text(stream.subTitle)
                        .font(.system(size: 12))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                VStack {
                    Slider(value: $stream.currentTime, in: 0...stream.viewDuration) { v in
                        stream.playerSeek(time: stream.currentTime)
                    }
                    .accentColor(.gray)
                    HStack {
                        Text(stream.time)
                            .font(.system(size: 10))
                        Spacer()
                        Text(stream.endTime)
                            .font(.system(size: 10))
                    }
                }.padding(20)
                
                HStack {
                    Spacer()
                    Button() {
                        stream.playerSeek(time: stream.currentTime - 15)
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 30))
                    }
                    .padding()
                    .disabled(stream.isLive)
                    
                    Spacer()
                    Button() {
                        if stream.isPlaying {
                            stream.pause()
                        } else {
                            stream.play()
                        }
                        
                    } label: {
                        if stream.isPlaying {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 50))
                        } else {
                            Image(systemName: "play.fill")
                                .font(.system(size: 50))
                        }
                    }
                    
                    Spacer()
                    Button() {
                        stream.playerSeek(time: stream.currentTime + 15)
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 30))
                    }
                    .padding()
                    .disabled(stream.isLive)
                    Spacer()
                }
                Spacer()
                
                HStack(spacing: 50) {
                    
                    AirPlayView()
                        .frame(width: 20, height: 20)
                        .darkLightForegroundColor()
                    Menu() {
                        Button("AAC 256Kbps (Best)") {
                            stream.changeQuality(sound: "http://stream.dubstep.fm/256aac")
                        }
                        Button("AAC 128Kbps (Heigh)") {
                            stream.changeQuality(sound: "http://stream.dubstep.fm/128aac")
                        }
                        Button("AAC 64Kbps (Medium)") {
                            stream.changeQuality(sound: "http://stream.dubstep.fm/64aac")
                        }
                        Button("AAC 24Kbps (Low)") {
                            stream.changeQuality(sound: "http://stream.dubstep.fm/24aac")
                        }
                    } label: {
                        Image(systemName: "list.bullet.circle.fill")
                            .font(.system(size: 20))
                    }
                }
                Spacer()
            }
        }.onViewDidLoad {
            stream.playSound(sound: "https://archive.dubstep.fm/ARCHIVE_-_2019-03-09_-_JVIZ_Presents_Earthquake_Weather_In_Los_Angeles.mp3")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
