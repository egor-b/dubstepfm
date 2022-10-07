//
//  PodcastDataManager.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/30/22.
//

import Foundation
import Alamofire

@MainActor
class PodcastDataManager: ObservableObject {
    
    @Published private(set) var podcast = [Podcast]()
    @Published private(set) var isLoading = false
        
    func fetchPodcasts() async {
        isLoading = true
        AF.request("https://www.dubstep.fm/archive.xml", method: .get).validate().responseString { resp in
            switch resp.result {
            case .success(let suceess):
                let parsePodcast = PodcastXmlParser()
                parsePodcast.parseFeed(data: Data(suceess.utf8))
                self.podcast = parsePodcast.podcasts
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoading = false
        }
    }
    
}

