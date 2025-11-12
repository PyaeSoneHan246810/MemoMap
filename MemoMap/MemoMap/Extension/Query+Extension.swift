//
//  Query+Extension.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation
import FirebaseFirestore

extension Query {
    func getDocumentModels<T: Decodable>(as type: T.Type) async throws -> [T] {
        let querySnapshot = try await self.getDocuments()
        let documents = querySnapshot.documents
        let models = documents.compactMap { querySnapshotDocument in
            try? querySnapshotDocument.data(as: type)
        }
        return models
    }
}
