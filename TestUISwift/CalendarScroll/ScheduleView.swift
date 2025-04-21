import SwiftUI

struct ScheduleView: View {
    @State private var selectedDate: Date = Date()
    @State private var events: [Event] = generateMockEvents()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CalendarView(selectedDate: $selectedDate)
                    .background(Color.blue.opacity(0.2))

                EventsListView(selectedDate: $selectedDate, events: events)
            }
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            DatePicker("Выберите дату", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .frame(maxHeight: 300)
        }
        .padding()
    }
}

struct EventsListView: View {
    @Binding var selectedDate: Date
    let events: [Event]

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(events) { event in
                            EventRow(event: event)
                                .id(event.id) // Теперь id гарантированно уникальный
                        }

                        // Заполняем пространство, если событий мало
                        let remainingSpace = geometry.size.height - CGFloat(events.count * 60)
                        if remainingSpace > 0 {
                            Spacer().frame(height: remainingSpace)
                        }
                    }
                }
                .onChange(of: selectedDate) { newDate in
                    if let matchingEvent = events.first(where: { Calendar.current.isDate($0.date, inSameDayAs: newDate) }) {
                        withAnimation {
                            proxy.scrollTo(matchingEvent.id, anchor: .top)
                        }
                    }
                }
            }
        }
        .background(.red)
        .frame(height: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

struct EventRow: View {
    let event: Event

    var body: some View {
        Text(event.title)
            .frame(maxWidth: .infinity, minHeight: 60) // minHeight добавляет стабильность высоты
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 1)
    }
}

struct Event: Identifiable {
    let id: String
    let date: Date
    let title: String

    init(date: Date, title: String) {
        self.id = "\(date.timeIntervalSince1970)-\(title)" // Гарантированно уникальный id
        self.date = date
        self.title = title
    }
}

func generateMockEvents() -> [Event] {
    let calendar = Calendar.current
    let today = Date()
    return (0..<5).map { i in
        let date = calendar.date(byAdding: .day, value: i, to: today)!
        return Event(date: date, title: "Событие \(i + 1) на \(formattedDate(date))")
    }
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
