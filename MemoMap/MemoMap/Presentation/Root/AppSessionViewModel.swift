//
//  AppSessionViewModel.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import Observation
import Factory

@Observable
final class AppSessionViewModel {
    
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    private(set) var appSession: AppSession = .unauthenticated
    
    func configureAppSession() {
        let userData = authenticationRepository.getUserData()
        appSession = userData != nil ? .authenticated : .unauthenticated
    }
    
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
