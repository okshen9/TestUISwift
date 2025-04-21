//
//  LandmarkView.swift
//  TestUISwift
//
//  Created by artem on 02.03.2025.
//

import SwiftUI

struct LandmarkView: View {
    var body: some View {
        LandmarkList()
    }
}

#Preview {
    LandmarkView()
        .environment(ModelData())
}
