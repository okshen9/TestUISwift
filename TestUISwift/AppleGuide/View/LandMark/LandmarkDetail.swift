//
//  CircleImage.swift
//  TestUISwift
//
//  Created by artem on 26.02.2025.
//

import SwiftUI
import MapKit

struct LandmarkDetail: View {
    
    @Environment(ModelData.self) var modelData
    @State var loccaile: CLLocationCoordinate2D?
    @State var showMap: Bool = false
    var landmark: Landmark
    
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }
    
    var body: some View {
        @Bindable var modelData = modelData
        
        ScrollView {
            VStack {
                /// neshko
                MapView(coordinate: loccaile ?? landmark.locationCoordinate)
                    .onTapGesture {
                        withAnimation {
                            showMap = true
                        }
                    }
                    .frame(height: 200)
                ///Neshko
                CircleImage(image: landmark.image)
                    .offset(y: -130)
                    .padding(.bottom, -130)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(landmark.name)
                            .font(.title)
                        FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                    }
                    HStack {
                        Text(landmark.park)
                            .font(.subheadline)
                        Spacer()
                        Text(landmark.state)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    
                    Text("About \(landmark.name)")
                        .font(.title2)
                    Text(landmark.description)
                }
                .padding()
            }
            Spacer()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getCoordinates(for: "Сратов", completion:  {
                print("Саратов: \($0)")
                loccaile = $0
            })
        }
        .overlay(content: {
            if showMap {
                MapView2()
                    .shadow(radius: 16)
                    .padding(8)
                    .onTapGesture {
                        withAnimation{
//                            showMap = false
                        }
                        
                    }
            }
        })
    }
    
    func getCoordinates(for city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            if let location = placemarks?.first?.location {
                completion(location.coordinate)
            } else {
                completion(nil) // Ошибка или не найдено
            }
        }
    }
}


#Preview {
    let modelData = ModelData()
    return LandmarkDetail(landmark: modelData.landmarks[0])
        .environment(modelData)
}

#Preview("List") {
    LandmarkList()
        .environment(ModelData())
}




