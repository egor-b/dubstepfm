//
//  PodcastView.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/27/22.
//

import SwiftUI

struct PodcastView: View {
    
    @StateObject private var podcastDM = PodcastDataManager()
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(podcastDM.podcast, id: \.self) { podcast in
                    PodcatsCell(podcast: podcast)
                        .onTapGesture {
                            NotificationCenter.default.post(name: NSNotification.Name("com.audio.play"), object: nil, userInfo: ["link": podcast.link])
                        }
                }
            }.task {
                await podcastDM.fetchPodcasts()
            }.refreshable {
                await podcastDM.fetchPodcasts()
            }.overlay {
                if podcastDM.isLoading {
                    ProgressView()
                }
            }.navigationTitle("Podcast")
        }
        
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
    }
}
