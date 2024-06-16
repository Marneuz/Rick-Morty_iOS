
import Foundation

@MainActor
class CharacterDetailViewModel: ObservableObject {
    
    @Published private(set) var character: Character?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    
    private let characterService = CharacterService()
    
    private var currentCharactersPage = 0
    private var maxCharactersPages: Int?
    
    func fetchCharacter(_ id: Int) {
        isLoading = true
        error = nil
        
        Task {
            do {
                let characterResponse = try await characterService.getCharacter(id: id)
                
                isLoading = false
                character = characterResponse
            } catch (let error) {
                isLoading = false
                self.error = error
            }
        }
    
    }
    
}
