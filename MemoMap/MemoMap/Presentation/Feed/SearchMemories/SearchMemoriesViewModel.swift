//
//  SearchMemoriesViewModel.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class SearchMemoriesViewModel {
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    private(set) var searchMemoriesDataState: DataState<[MemoryData]> = .initial
    
    var searchText: String = ""
    
    var trimmedSearchText: String {
        searchText.trimmed()
    }
    
    func clearSearchText() {
        searchText = ""
    }
    
    func resetSearchState() {
        searchMemoriesDataState = .initial
    }
    
    func searchMemories() async {
        searchMemoriesDataState = .loading
        do {
            let memories = try await memoryRepository.searchMemoriesByLocationName(locationName: trimmedSearchText)
            searchMemoriesDataState = .success(memories)
        } catch {
            if let searchMemoriesError = error as? SearchMemoriesError {
                let errorDescription = searchMemoriesError.localizedDescription
                print(errorDescription)
                searchMemoriesDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                searchMemoriesDataState = .failure(errorDescription)
            }
        }
    }
}
