//
//  Landmark.swift
//  TestUISwift
//
//  Created by artem on 27.02.2025.
//


import Foundation
import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool


    private(set) var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    mutating func setImageName(_ name: String) {
        self.imageName = name
    }


    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }


    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
