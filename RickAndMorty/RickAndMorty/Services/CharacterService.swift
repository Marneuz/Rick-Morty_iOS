
import Foundation

class CharacterService {
    private let networkClient = URLSessionNetworkClient()
    
    func getCharacters(page: Int = 1) async throws -> CharactersResponse {
        return try await networkClient.getCall(url: ApiConstants.characterUrl, queryParams: ["page" : page.description])
    }
    
    func getCharacter(id: Int) async throws -> Character {
        return try await networkClient.getCall(url: "\(ApiConstants.characterUrl)/\(id)", queryParams: nil)
    }
}
