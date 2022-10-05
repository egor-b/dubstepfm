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
        List {
            ForEach(podcastDM.podcast, id: \.self) { podcast in
                Text("\(podcast.description) - \(podcast.pubDate)")
            }
        }.task {
            await podcastDM.fetchPodcasts()
        }.refreshable {
            await podcastDM.fetchPodcasts()
        }.overlay {
            if podcastDM.isLoading {
                ProgressView()
            }
        }
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
    }
}