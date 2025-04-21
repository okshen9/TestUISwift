//
//  LandmarkList.swift
//  TestUISwift
//
//  Created by artem on 27.02.2025.
//

import SwiftUI


struct LandmarkList: View {
    @Environment(ModelData.self) var modelData
    @State private var showFavoritesOnly = false
    
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List() {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredLandmarks) { lanmark in
                    NavigationLink {
                        LandmarkDetail(landmark: lanmark)
                    } label: {
                        LandmarkRow(landmark: lanmark)
                    }
                }
                .navigationTitle("Landmarks")
                

            }
            .animation(.default, value: filteredLandmarks)
        }
        detail: {
            Text("Detail")
        }
    }
}

//struct LandmarkList2: View {
//    @Environment(ModelData.self) var modelData
//    @State private var showFavoritesOnly = false
//    
//    var filteredLandmarks: [Landmark] {
//        modelData.landmarks.filter { landmark in
//            (!showFavoritesOnly || landmark.isFavorite)
//        }
//    }
//    
//    var body: some View {
////        NavigationSplitView {
//        NavigationStack {
//            List() {
//                Toggle(isOn: $showFavoritesOnly) {
//                    Text("Favorites only")
//                }
//                
//                ForEach(filteredLandmarks) { lanmark in
//                    NavigationLink {
//                        LandmarkDetail(landmark: lanmark)
//                    } label: {
//                        LandmarkRow(landmark: lanmark)
//                    }
//                }
//                .navigationTitle("Landmarks")
//            }
//            .animation(.default, value: filteredLandmarks)
//        }
////        detail: {
////            Text("Detail")
////        }
//    }
//}



#Preview {
    LandmarkList()
        .environment(ModelData())
//    LandmarkList2()
}
