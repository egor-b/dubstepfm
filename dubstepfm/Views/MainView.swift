//
//  MainView.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/27/22.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Radio", systemImage: "music.note")
                }
            
            PodcastView()
                .tabItem {
                    Label("Podcasts", systemImage: "list.dash.header.rectangle")
                }
            
        }
        .accentColor(colorScheme == .dark ? .white : .black)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.clear)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
