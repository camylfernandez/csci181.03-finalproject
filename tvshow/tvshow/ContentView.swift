//
//  ContentView.swift
//  tvshow
//
//  Created by Kyra Hung on 4/20/23.
//

import SwiftUI

struct Episode: Codable {
    let air_date: String?
    let episode_number: Int?
    let id: Int
    let name: String
    let overview: String
    let still_path: String? // image
}

struct TVShowResponse : Codable {
    let episodes: [Episode]
    let overview: String
    let poster_path: String?
}

struct ContentView: View {
    @State var tvShowResponse: TVShowResponse?
    @State var episodeNames: [String] = []
    @State var isOn: [Bool] = []
    @State private var showInfoView = false
    
    /// watchedEpisodeIds is an array of integers that represent the id of an episode that has a checked checkbox
    /// the zip function combines an array of episodes with the isOn array
    /// .filter{ $0.1 } only gets the episodes where isOn = true
    /// .map { $0.0.id } puts the ids of the remaining episodes in the watchedEpisodeIds array
    var watchedEpisodeIds: [Int] {
        let watchedEpisodes = zip(tvShowResponse?.episodes ?? [], isOn)
            .filter { $0.1 }
            .map { $0.0.id }
        return watchedEpisodes
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Season 1")) {
                    ForEach(episodeNames.indices, id: \.self) { index in
                        NavigationLink(destination: EpisodeInfoView(episode: tvShowResponse?.episodes[index] ?? Episode(air_date: "", episode_number: 0, id: 0, name: "", overview: "", still_path: ""))) {
                            HStack {
                                Text("\(index+1). \(episodeNames[index])")
                                Spacer()
                                Image(systemName: isOn[index] ? "checkmark.square" : "square")
                                    .onTapGesture {
                                        isOn[index].toggle()
                                        saveCheckboxState()
                                    }
                                    .toggleStyle(iOSCheckboxToggleStyle(isChecked: $isOn[index]))
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle("You")
            .navigationBarItems(trailing:
                Button(action: {
                    // Navigate to TVShowInfoView when button is tapped
                    self.showInfoView = true
                }) {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                }
                .sheet(isPresented: $showInfoView) {
                    TVShowInfoView(tvshow: tvShowResponse ?? TVShowResponse(episodes: [], overview: "", poster_path: ""))
                }
            )
        }
        .onAppear {
            loadCheckboxState()
            makeAPIcall()
        }
    }
    
    func makeAPIcall() {
        let url = URL(string: "https://api.themoviedb.org/3/tv/78191/season/1?api_key=75f7cffa9544a6656df6207faf0fc944&language=en-US")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data returned from API.")
                return
            }
            
            do {
                let tvShowResponse = try JSONDecoder().decode(TVShowResponse.self, from: data)
                DispatchQueue.main.async {
                    self.tvShowResponse = tvShowResponse
                    self.episodeNames = tvShowResponse.episodes.map { $0.name }
                    self.isOn = Array(repeating: false, count: self.episodeNames.count)
                    self.loadCheckboxState()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        task.resume()
    }
    
    func saveCheckboxState() {
        UserDefaults.standard.set(watchedEpisodeIds, forKey: "watchedEpisodeIds")
    }
    
    func loadCheckboxState() {
        if let state = UserDefaults.standard.array(forKey: "watchedEpisodeIds") as? [Int] {
            /// if the episdoe is not in the watchedEpisodeIDs array, isOn = false
            isOn = Array(repeating: false, count: episodeNames.count)
            /// for each id in the array, we get the corresponsing episode of the id and make isOn = true
            for id in state {
                if let index = tvShowResponse?.episodes.firstIndex(where: { $0.id == id }) {
                    isOn[index] = true
                }
            }
        } else {
            isOn = Array(repeating: false, count: episodeNames.count)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// From: https://sarunw.com/posts/swiftui-checkbox/
struct iOSCheckboxToggleStyle: ToggleStyle {
    var isChecked: Binding<Bool>
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            isChecked.wrappedValue.toggle()
        }, label: {
            HStack {
                Image(systemName: isChecked.wrappedValue ? "checkmark.square" : "square")
                configuration.label
            }
        })
        .buttonStyle(BorderlessButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            isChecked.wrappedValue.toggle()
        })
    }
}

