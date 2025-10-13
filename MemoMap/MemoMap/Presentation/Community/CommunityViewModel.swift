//
//  CommunityViewModel.swift
//  MemoMap
//
//  Created by Dylan on 12/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class CommunityViewModel {
    
    var selectedConnectionType: CommunityScreenView.ConnectionType = .followers
    
}
