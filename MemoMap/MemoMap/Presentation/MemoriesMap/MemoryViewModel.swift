//
//  MemoryViewModel.swift
//  MemoMap
//
//  Created by Dylan on 19/10/25.
//

import Foundation
import Observation
import Factory

@Observable
class MemoryViewModel {
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    var updatedMemory: MemoryData? = nil
    
    var isEditMemorySheetPresented: Bool = false
    
    var editMemoryInfo: EditMemoryInfo = .init(title: "", description: "", tags: [], dateTime: .now, publicStatus: true)
    
    func editMemoryInfo(for memoryId: String) async {
        do {
            try await memoryRepository.updateMemoryInfo(
                memoryId: memoryId, editMemoryInfo: editMemoryInfo
            )
            await getUpdatedMemory(for: memoryId)
            isEditMemorySheetPresented = false
        } catch {
            if let updateMemoryInfoError = error as? UpdateMemoryInfoError {
                print(updateMemoryInfoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func getUpdatedMemory(for memoryId: String) async {
        do {
            let memory = try await memoryRepository.getMemory(memoryId: memoryId)
            updatedMemory = memory
        } catch {
            if let updateMemoryInfoError = error as? UpdateMemoryInfoError {
                print(updateMemoryInfoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
}
