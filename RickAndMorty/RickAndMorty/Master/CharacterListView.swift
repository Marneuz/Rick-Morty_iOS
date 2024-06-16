

import SwiftUI
import Lottie

struct CharacterListView: View {
    
    @StateObject private var characterListViewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(characterListViewModel.characterList) { character in
                    NavigationLink(destination: CharacterDetailView(id: character.id)) {
                        HStack {
                            AsyncImage(url: URL(string: character.image)) { state in
                                switch state {
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 56, height: 56)
                                case .empty:
                                    ProgressView()
                                        .frame(width: 56, height: 56)
                                case .failure(_):
                                    Image(systemName: "person.crop.circle.badge.xmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 56, height: 56)
                                default:
                                    EmptyView()
                                }
                            }
                            Text(character.name)
                        }
                    }.onAppear {
                        if characterListViewModel.characterList.last?.id == character.id {
                            fetchCharacters(enablePaging: true)
                        }
                    }
                }
            }.navigationTitle("Characters")
            
            if characterListViewModel.isLoading {
                VStack {
                    LottieView(filename: "animation_loading", loopMode: .loop)
                        .frame(width: 80, height: 80)
                }
            }
        }.onAppear {
            fetchCharacters()
        }.alert(getErrorText(), isPresented: Binding.constant(characterListViewModel.error != nil)) {
            Button("OK", role: .cancel) {}
            Button("Retry", role: .none) {
                fetchCharacters()
            }
        }
    }
    
    private func getErrorText() -> String {
        guard let error = characterListViewModel.error, error is NetworkError else {
            return ""
        }
        
        switch error as! NetworkError {
        case .response(let statusCode):
            return "ERROR: Statuscode: \(statusCode)"
        case .encoding:
            return "ERROR: Data can not be converted"
        default:
            return "ERROR: Unknown"
        }
    }
    
    private func fetchCharacters(enablePaging: Bool = false) {
        characterListViewModel.fetchCharacters(enablePaging: enablePaging)
    }
}

#Preview {
    CharacterListView()
}
