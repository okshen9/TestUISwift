//
//  ContentView.swift
//  TestUISwift
//
//  Created by artem on 03.03.2025.
//

import SwiftUI
import MapKit
import Combine

struct MapView2: View {
    // Регион карты (центр и зум)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176), // Москва
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        Map(position: .constant(.region(region))) {
            // Добавляем маркер (аннотацию) на карту
            Annotation("Москва", coordinate: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .font(.title)
            }
            // Добавляем полилинию (линию на карте)
            MapPolyline(coordinates: [
                CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
                CLLocationCoordinate2D(latitude: 55.7600, longitude: 37.6200)
            ])
            .stroke(.blue, lineWidth: 3)
        }
        .mapStyle(.standard) // Стиль карты
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MapView2()
}
