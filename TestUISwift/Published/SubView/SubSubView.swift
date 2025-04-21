//
//  SubSubView.swift
//  TestUISwift
//
//  Created by artem on 02.03.2025.
//

import SwiftUI

struct SubSubView: View {
    @EnvironmentObject var viewModel: PublishedTestingViewModel 
    var model: SubSubPubModel
    var body: some View {
        Text("-- SubSubView: \(model.subSubText ?? "SubSubPubModel is Nil")")
            .padding(4)
            .background(Color.cyan)
            .cornerRadius(4)
            .onTapGesture(count: 2, perform: {
                viewModel.changeSubSubView()
            })
    }
}

#Preview {
    SubSubView(model: .init(subSubText: "SubSubPubModel 1"))
        .environmentObject(PublishedTestingViewModel())
}
