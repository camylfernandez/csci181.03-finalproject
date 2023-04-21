//
//  TVShowInfoView.swift
//  tvshow
//
//  Created by Caitlin Hung on 4/21/23.
//

import SwiftUI

struct TVShowInfoView: View {
    let tvshow: TVShowResponse
    
    var body: some View {
        VStack {
            Spacer()
            Text("You").fontWeight(.bold).font(.largeTitle)
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(tvshow.poster_path ?? "")")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 200, height: 300)
            Spacer().frame(height: 20)
            Text(tvshow.overview).multilineTextAlignment(.center).padding(20)
            Spacer()
        }
        
    }
}

struct TVShowInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowInfoView(tvshow: TVShowResponse(episodes: [], overview: "testing testing testing testing testing testing testing testing testing testing", poster_path: "/lDsJxWEVDZCi6UXBLwAcyh2Z6n.jpg"))
    }
}
