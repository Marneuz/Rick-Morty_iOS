
import SwiftUI

struct CharacterDetailView: View {
    
    let id: Int
    
    @StateObject private var characterDetailViewModel = CharacterDetailViewModel()
    @State private var showErrorAlert = false
    
    var body: some View {
        ZStack {
            if let character = characterDetailViewModel.character {
                ScrollView {
                    VStack {
                        Text(character.name)
                            .bold()
                            .font(.system(size: 24))
                            .padding()
                        AsyncImage(url: URL(string: character.image)) { state in
                            switch state {
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 240, height: 240)
                                    .padding()
                            case .empty:
                                ProgressView()
                                    .frame(width: 240, height: 240)
                                    .padding()
                            case .failure(_):
                                Image(systemName: "person.crop.circle.badge.xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 240, height: 240)
                                    .padding()
                            default:
                                EmptyView()
                            }
                            
                        }
                        Text("\(character.gender) - \(character.species)")
                        Text(character.origin.name)
                    }
                }
            }
            
            if characterDetailViewModel.isLoading {
                VStack {
                    LottieView(filename: "animation_loading", loopMode: .loop)
                        .frame(width: 80, height: 80)
                }
            }
        }.onAppear {
            characterDetailViewModel.fetchCharacter(id)
        }.alert("Error", isPresented: Binding.constant(characterDetailViewModel.error != nil)) {
            Button("OK", role: .cancel) {}
            Button("Retry", role: .none) {
                characterDetailViewModel.fetchCharacter(id)
            }
        } message: {
            Text(getErrorText())
        }
    }
    
    private func getErrorText() -> String {
        guard let error = characterDetailViewModel.error, error is NetworkError else {
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
}

#Preview {
    CharacterDetailView(id: 1)
}
