
import Foundation

@MainActor
class CharacterListViewModel: ObservableObject {
    
    @Published private(set) var characterList: [Character] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    
    private let characterService = CharacterService()
    
    private var currentCharactersPage = 0
    private var maxCharactersPages: Int?
    
    func fetchCharacters(enablePaging: Bool = false) {
        if let maxPages = maxCharactersPages, maxPages == currentCharactersPage {
            return
        }
        
        if enablePaging {
            currentCharactersPage += 1
        } else {
            currentCharactersPage = 1
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let charactersResponse = try await characterService.getCharacters(page: currentCharactersPage)
                
                maxCharactersPages = charactersResponse.info.pages
                
                isLoading = false
                characterList.append(contentsOf: charactersResponse.characters)
            } catch (let error) {
                isLoading = false
                self.error = error
            }
        }
    }
    
}
