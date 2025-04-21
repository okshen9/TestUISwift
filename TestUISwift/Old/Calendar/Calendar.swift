//
//  Calendar.swift
//  TestUISwift
//
//  Created by artem on 23.02.2025.
//

import SwiftUI

struct CalendarViewSUI: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        DatePicker(
            "Data sdfsdf",
            selection: .constant(Date()),
            displayedComponents: [.date])
                .datePickerStyle(.graphical)

    }
}

#Preview {
    CalendarViewSUI()
}
