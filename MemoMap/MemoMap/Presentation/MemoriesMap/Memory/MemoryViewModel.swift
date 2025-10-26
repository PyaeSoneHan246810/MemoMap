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
    
    var memoryToEdit: MemoryData? = nil
    
    var isEditMemoryInfoViewPresented: Bool = false
    
    var editMemoryInfo: EditMemoryInfo = .init(title: "", description: "", tags: [], dateTime: .now, publicStatus: true)
    
    private(set) var isEditMemoryInfoInProgress: Bool = false
    
    private(set) var updateMemoryInfoError: UpdateMemoryInfoError? = nil
    
    var isEditMemoryInfoAlertPresented: Bool = false
    
    func editMemoryInfo(for memoryId: String) async {
        isEditMemoryInfoInProgress = true
        do {
            try await memoryRepository.updateMemoryInfo(
                memoryId: memoryId, editMemoryInfo: editMemoryInfo
            )
            isEditMemoryInfoInProgress = false
            updateMemoryInfoError = nil
            isEditMemoryInfoAlertPresented = false
            isEditMemoryInfoViewPresented = false
            await getUpdatedMemory(for: memoryId)
        } catch {
            isEditMemoryInfoInProgress = false
            if let updateMemoryInfoError = error as? UpdateMemoryInfoError {
                self.updateMemoryInfoError = updateMemoryInfoError
            } else {
                self.updateMemoryInfoError = .updateFailed
            }
            isEditMemoryInfoAlertPresented = true
        }
    }
    
    func getUpdatedMemory(for memoryId: String) async {
        let memory = try? await memoryRepository.getMemory(memoryId: memoryId)
        updatedMemory = memory
    }
}
