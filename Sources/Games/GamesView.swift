import SwiftUI

struct GamesView: View {
    
    @StateObject
    var viewModel = GamesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataSourceGamesModelView ?? []) { item in
                GameCard(game: item)
            }
        }
        .environment(\.defaultMinListRowHeight, 100)
        .navigationTitle("gamesToday")
        .onAppear {
            self.viewModel.fetchData()
        }
        .refreshable {
            self.viewModel.fetchData()
        }
    }
}

struct GameCard: View {
    
    @ObservedObject
    var imageLoader1 = ImageLoader()
    
    @ObservedObject
    var imageLoader2 = ImageLoader()
    
    private var game: GamesModelView
    
    init(game: GamesModelView) {
        self.game = game
        self.imageLoader1.loadImage(with: game.homeTeam.logoUrl)
        self.imageLoader2.loadImage(with: game.visitorTeam.logoUrl)
        
    }
    
    
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack {
                    if imageLoader1.image != nil {
                        Image(uiImage: self.imageLoader1.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                    Text(game.homeTeam.name ?? "")
                }
                Spacer()
                VStack {
                    if imageLoader2.image != nil {
                        Image(uiImage: self.imageLoader2.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }
                    Text(game.visitorTeam.name ?? "")
                }
            }
            Spacer()
            switch(game.status) {
            case "In Play":
                Text("inPlay")
            case "Finished":
                VStack {
                    Text("finished")
                    HStack {
                        Text(game.homeScore ?? "")
                        Spacer()
                        Text(game.visitorScore ?? "")
                    }
                }
            default:
                VStack {
                    Text("scheduled")
                    switch(Locale.current.languageCode) {
                    case "es":
                        Text(Utils.formattedDateTime(dateTime: game.dateTime, languageCode: "es") ?? "")
                    default:
                        Text(Utils.formattedDateTime(dateTime: game.dateTime, languageCode: "en") ?? "")
                    }
                }
            }
        }
    }
}


struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}

