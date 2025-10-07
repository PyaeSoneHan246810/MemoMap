//
//  Place.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation
import MapboxMaps

struct Place: Identifiable {
    let coordinate: CLLocationCoordinate2D
    var latitude: Double {
        coordinate.latitude
    }
    var longitude: Double {
        coordinate.longitude
    }
    var id: String {
        "\(latitude)&\(longitude)"
    }
}
