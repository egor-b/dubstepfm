//
//  PodcatsCell.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 10/7/22.
//

import SwiftUI

struct PodcatsCell: View {
    var podcast: Podcast
    var body: some View {
        
        HStack {
            Image("dsfm_cover")
                .resizable()
                .frame(width: 65, height: 65)
                .aspectRatio(contentMode: .fit)
            
            VStack(spacing: 6) {
                Text(podcast.description)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                HStack {
                    Text(podcast.album)
                        .italic()
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 11))
                        .lineLimit(1)
                    Text("Season:")
                        .font(.system(size: 11))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                    Text(podcast.season)
                        .italic()
                        .font(.system(size: 11))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }

                Text(podcast.pubDate)
                    .font(.system(size: 10))
                    .fontWeight(.light)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        
    }
}

struct PodcatsCell_Previews: PreviewProvider {
    static var previews: some View {
        let p = Podcast(author: "Dubstep.fm", album: "Dubstep.fm Archives - 2018", season: "2018", pubDate: "Wed, 05 Sep 2018", description: "JVIZ Presents Earthquake Weather In Los Angeles", fullDescription: "DUBSTEP.FM ARCHIVE - 2018-09-05 - JVIZ Presents Earthquake Weather In Los Angeles", link: "https://archive.dubstep.fm/ARCHIVE_-_2018-09-05_-_JVIZ_Presents_Earthquake_Weather_In_Los_Angeles.mp3", cover: "https://www.dubstep.fm/images/dsfm_cover.jpg")
        PodcatsCell(podcast: p)
    }
}
