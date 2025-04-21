//
//  SubView.swift
//  TestUISwift
//
//  Created by artem on 01.03.2025.
//

import SwiftUI

struct SubView: View {
    @EnvironmentObject var viewModel: PublishedTestingViewModel 
    var model: SubPubModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("- SubView: \(model.subText ?? "SubView is Nil")")
            if let subsubModel = model.subSubPubModel {
                SubSubView(model: subsubModel)
            }
        }
        .padding(4)
        .background(.brown)
        .cornerRadius(8)
        .onTapGesture(count: 2, perform: {
            viewModel.changeSubView()
        })
        
    }
}

#Preview {
    SubView(model: .init(subText: "SubPubModel 1",
                         subSubPubModel: .init(subSubText: "SubSubPubModel 1")))
    .environmentObject(PublishedTestingViewModel())
}
