//
//  AppSessionManager.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import Observation

@MainActor
@Observable
final class AppSessionViewModel {
    private(set) var appSession: AppSession = .unauthenticated
    
    func changeAppSession(_ appSession: AppSession) {
        self.appSession = appSession
    }
}

extension AppSessionViewModel {
    enum AppSession {
        case authenticated
        case unauthenticated
    }
}
