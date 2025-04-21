//
//  TestTarget.swift
//  TestUISwift
//
//  Created by artem on 17.02.2025.
//

import Foundation
import SwiftUI
import Combine

struct TestView: View {
    
    var body: some View {
//        Button("Tap me") {
//            var landmarks = ModelData().landmarks
//            var tempMark = landmarks[0]
//            tempMark.setImageName("temp")
//            tempMark.id = -1
//            landmarks[0] = tempMark
////            landmarks[0].setImageName("temp")
//            print("Mark: Start change ===")
//            print(landmarks.map{$0.image}, separator: "\n")
//            print("Mark: End change ===")
//        }
//        LandmarkList()
        
//        BadgeBackground()
//            .frame(width: 300, height: 300)
//        PublishedTestingView()
//            .onAppear {
//                print("Mark: Start ===")
//                print(ModelData().landmarks.map{$0.imageName}, separator: "\n")
//                print("Mark: End ===")
//            }
        
//        CustomWrapper()
//        EquatableContentView()
        
//        CustomCalendarView(selectedDate: Date.now)

//        let viewModel = ProfileInfoViewModel()
//        ProfileInfoView(viewModel: viewModel)

        AuthSUIView()

//        CategoryChartView(categories: [
//            Category(color: .blue, name: "Работа", progressValue: 0.7),
//            Category(color: .green, name: "Отдых", progressValue: 0.4),
//            Category(color: .orange, name: "Спорт", progressValue: 0.6)
//        ])
    }
    

}

#Preview {
    TestView()
}
