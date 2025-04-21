//
//  CustomCalendarView.swift
//  TestUISwift
//
//  Created by artem on 23.02.2025.
//


import SwiftUI
import Foundation

struct CustomCalendarView2: View {
    @State var selectedDate: Date
    let markedDates: [Date: [UIColor]] = [
        Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 5))!: [.red],
        Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3))!: [.blue, .green]
    ]

    var body: some View {
        VStack {
//            DatePicker("Выберите дату", selection: $selectedDate)
//                .datePickerStyle(.graphical)
            CalendarViewUIKit(selectedDate: $selectedDate, events: markedDates2)
                .frame(height: 400)

//            if let selectedDate = selectedDate {
                Text("Выбранная дата: \(selectedDate.formatted(.dateTime.day().month().year()))")
//            } else {
//                Text("Дата не выбрана")
//            }
        }
        .padding()
    }
}

#Preview {
    CustomCalendarView2(selectedDate: Date.now)
}
