//
//  EpisodeInfoView.swift
//  tvshow
//
//  Created by Kyra Hung on 4/21/23.
//

import SwiftUI

struct EpisodeInfoView: View {
    let episode: Episode
    
    var body: some View {
        Text("Placeholder Text")
        .navigationTitle(episode.name)
        /// you can put the episode's overview, image, and airdate here
    }
}


struct EpisodeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        /// these values are just for testing so you can see what it looks like in the preview but in the actual app, it will load the info for the selected episode
        EpisodeInfoView(episode: Episode(air_date: "2018-09-09", episode_number: 1, id: 12345, name: "Pilot", overview: "testing testing testing overview text overview text", still_path: "/sFILcK0exJVJV4BZMAOPzpBEuUT.jpg"))
    }
}
