//
//  CalendarViewUIKit.swift
//  TestUISwift
//
//  Created by artem on 23.02.2025.
//


import SwiftUI
import UIKit

struct CalendarViewUIKit: UIViewRepresentable {
    @Binding var selectedDate: Date
    let events: [DateComponents: [UIColor]] // Несколько событий на одну дату

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarViewUIKit

        init(_ parent: CalendarViewUIKit) {
            self.parent = parent
            print("----")
            for event in parent.events {
                print("Neshko2: \(event.key.description)")
            }
            print("----")
        }

        func calendarView(_ calendarView: UICalendarView,
                          decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let calendar = Calendar.current
//            print("Neshko: day:\(dateComponents.day?.description ?? "nil"), month:\(dateComponents.month?.description ?? "nil"), year:\(dateComponents.year?.description ?? "nil")")
            print("Neshko: \(dateComponents)")
            

            
            guard
                let colors = parent.events.first(where: { $0.key.equalDate(dateComponents)})?.value else {
                return nil
            }
            
            // Генерация иконки с цветными точками
            let image = generateMultiStripeImage(colors: colors)
            return .image(image)
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents = dateComponents, let date = Calendar.current.date(from: dateComponents) else { return }
            DispatchQueue.main.async {
                self.parent.selectedDate = date
            }
        }

        /// Создает изображение с цветными точками
        private func generateMultiStripeImage(colors: [UIColor]) -> UIImage {
            let size = CGSize(width: 34, height: 16) // Размер иконки
            let renderer = UIGraphicsImageRenderer(size: size)

            return renderer.image { ctx in
                let stripeHeight: CGFloat = 3  // Высота полоски
                let spacing: CGFloat = 1       // Отступ между полосками
                let maxVisibleStripes = 2      // Отображаем не больше 2 полосок
                let totalStripes = min(colors.count, maxVisibleStripes)
                
                let totalHeight = CGFloat(totalStripes) * (stripeHeight + spacing) - spacing
                var yOffset = 0.0 //(size.height - totalHeight) / 2  // Центрирование

                for i in 0..<totalStripes {
                    let rect = CGRect(x: 0, y: yOffset, width: size.width, height: stripeHeight)
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: 1.5)
                    
                    ctx.cgContext.setFillColor(colors[i].cgColor)
                    ctx.cgContext.addPath(path.cgPath)
                    ctx.cgContext.fillPath()
                    
                    yOffset += stripeHeight + spacing
                }

                // Если событий больше 3, рисуем +n
                if colors.count > maxVisibleStripes {
                    let number = colors.count - maxVisibleStripes
                    let numberText = "+\(number)"
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 6, weight: .bold),
                        .foregroundColor: UIColor.black
                    ]
                    let textSize = numberText.size(withAttributes: attributes)
                    let textRect = CGRect(
                        x: (size.width - textSize.width) / 2,
                        y: size.height - textSize.height - 1,
                        width: textSize.width,
                        height: textSize.height
                    )
                    numberText.draw(in: textRect, withAttributes: attributes)
                }
            }
        }
    }
}


struct CustomCalendarView: View {
    @State var selectedDate: Date


    var body: some View {
        VStack {
            CalendarViewUIKit(selectedDate: $selectedDate, events: markedDates2)
                .tint(Color.red)
                .frame(height: 400)
            Text("Выбранная дата: \(selectedDate.formatted(.dateTime.day().month().year()))")
        }
        .padding()
    }
}

#Preview {
    CustomCalendarView(selectedDate: Date.now)
}


let markedDates: [Date: [UIColor]] = [
    Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 5))!: [.red],
    Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3))!: [.blue, .green,
                                                                                 .blue, .orange,.yellow,.darkGray,.brown]
]

let markedDates2: [DateComponents: [UIColor]] = [
    //DateComponents(year: 2025, month: 3, day: 5)
    DateComponents(year: 2025, month: 2, day: 5): [.red],
    DateComponents(year: 2025, month: 3, day: 3): [.blue, .green,
                                                                                 .blue, .orange,.yellow,.darkGray,.brown]
]

extension Date {
    /// Компонетны даты год, месяц, день
    func dateComponentsFor(_ dateComponents: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents(dateComponents, from: self)
    }
}

extension DateComponents {
    
    func equalDate(_ dateComponents: DateComponents) -> Bool {
        return self.year == dateComponents.year && self.month == dateComponents.month && self.day == dateComponents.day
    }
}
