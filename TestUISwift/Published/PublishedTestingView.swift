//
//  PublishedTesting.swift
//  TestUISwift
//
//  Created by artem on 01.03.2025.
//

import SwiftUI

struct PublishedTestingView: View {
    @ObservedObject var viewModel = PublishedTestingViewModel()
    var body: some View {
        VStack {

            buttonSection()
            
            ForEach(PubType.allCases, id: \.self) { category  in
                section(category: category)
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
    
    @ViewBuilder
    func section(category: PubType) -> some View {
        HStack {
            if let tasks = viewModel.gropedTask[category], !tasks.isEmpty {
                Text(category.rawValue)
                VStack {
                    ForEach(tasks) { task in
                        VStack {
                            Text(task.text).foregroundColor(.red)
                            if let subPubModel = task.subPubModel {
                                SubView(model: subPubModel)
                            }
                        }
                    }
                }
            } else {
                EmptyView()
            }
        }
        .padding()
        .background(.gray)
        .cornerRadius(8)
    }
    
    @ViewBuilder
    func buttonSection() -> some View {
        HStack {
            Button(action: {
                viewModel.changeTitle()
            }, label: {
                Text("Title +0")
            })
            .padding(4)
            .background(Color.black)
            .cornerRadius(4)
            
            Button(action: {
                viewModel.changeSubView()
            }, label: {
                Text("SubView +0")
            })
            .padding(4)
            .background(Color.black)
            .cornerRadius(4)
            
            Button(action: {
                viewModel.changeSubSubView()
            }, label: {
                Text("SubSubView +0")
            })
            .padding(4)
            .background(Color.black)
            .cornerRadius(4)
        }
    }
}



#Preview {
    let viewModel = PublishedTestingViewModel()
    viewModel.task = [
        .init(text: "111", type: PubType.one, subPubModel: .init(subText: "1111", subSubPubModel: .init(subSubText: "11111"))),
        .init(text: "222", type: PubType.two, subPubModel: .init(subText: "2222", subSubPubModel: .init(subSubText: "22222"))),
        .init(text: "333", type: PubType.three, subPubModel: .init(subText: "3333", subSubPubModel: .init(subSubText: "33333"))),
        .init(text: "444", type: PubType.forth, subPubModel: .init(subText: "4444", subSubPubModel: .init(subSubText: "44444")))
    ]
    return PublishedTestingView(viewModel: viewModel)
}
