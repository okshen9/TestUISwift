//
//  PublishedTestingViewModel.swift
//  TestUISwift
//
//  Created by artem on 01.03.2025.
//

import Foundation
import Combine

class PublishedTestingViewModel: ObservableObject {
    @Published var task: [PubModel] = []
    @Published var gropedTask: [PubType: [PubModel]] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $task
            .map { targets in
                Dictionary(grouping: targets, by: { $0.type ?? .one })
            }
            .sink { [weak self] groupedTargets in
                self?.gropedTask = groupedTargets
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func loadData() async {
        do {
            try await Task.sleep(for: .seconds(5))
            await MainActor.run {
                self.task = [
                    .init(text: "111", type: PubType.one, subPubModel: .init(subText: "1111", subSubPubModel: .init(subSubText: "11111"))),
                    .init(text: "222", type: PubType.two, subPubModel: .init(subText: "2222", subSubPubModel: .init(subSubText: "22222"))),
                    .init(text: "333", type: PubType.three, subPubModel: .init(subText: "3333", subSubPubModel: .init(subSubText: "33333"))),
                    .init(text: "444", type: PubType.forth, subPubModel: .init(subText: "4444", subSubPubModel: .init(subSubText: "44444")))
                ]
                print("Done Neshko")
            }
            
        }
        catch {
            print(error)
        }
    }
    
    @MainActor
    func changeTitle() {
        self.task[0].text = self.task[0].text + "0"
    }
    
    @MainActor
    func changeSubView() {
        self.task[0].subPubModel?.subText = (self.task[0].subPubModel?.subText ?? "") + "0"
        print("subPubModel.subText: \(self.task[0].subPubModel?.subText ?? "99")")
    }
    
    @MainActor
    func changeSubSubView() {
        self.task[0].subPubModel?.subSubPubModel?.subSubText = (self.task[0].subPubModel?.subSubPubModel?.subSubText ?? "") + "0"
        print("subSubPubModel.subSubText: \(self.task[0].subPubModel?.subSubPubModel?.subSubText ?? "999")")
    }
}


struct PubModel: Identifiable {
    var id = UUID()
    
    var text: String
    var type: PubType?
    var subPubModel: SubPubModel?
}

enum PubType: String, CaseIterable, Equatable {
    case one = "one"
    case two = "two"
    case three = "three"
    case forth = "forth"
}


struct SubPubModel: Identifiable {
    var id = UUID()
    var subText: String?
    var subSubPubModel: SubSubPubModel?
}

struct SubSubPubModel: Identifiable {
    var id = UUID()
    var subSubText: String?
}
