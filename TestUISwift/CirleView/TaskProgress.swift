//
//  TaskProgress.swift
//  TestUISwift
//
//  Created by artem on 23.03.2025.
//

import SwiftUI

struct TaskProgress2: Identifiable {
    let id = UUID()
    var progress: Double // 0.0 - 1.0
    var color: Color
    var name: String
    var value: Double // Доля в круге (рекомендуется сумма = 1.0)
}

struct SegmentedProgressRing2: View {
    var tasks: [TaskProgress2]
    var lineWidth: CGFloat = 20


    private var separatorValue: Double {
        let total = normalizedTasks.reduce(0) { $0 + $1.value }
        guard total > 0 else { return 0 }
        return (total/(360.0 - 3 * Double(normalizedTasks.count))) * 3
    }

    // Нормализация значений
    private var normalizedTasks: [TaskProgress2] {
        let total = tasks.reduce(0) { $0 + $1.value }
        guard total > 0 else { return [] }

        return tasks.map { task in
            var t = task
            t.value = task.value / total
            return t
        }
    }

    var body: some View {
        ZStack {
            // Фоновые сегменты
            ForEach(normalizedTasks) { task in
                let startAngle = startAngle(for: task)

                Circle()
                    .trim(from: 0, to: CGFloat(task.value))
                    .stroke(
                        task.color.opacity(0.3),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(startAngle)
            }

            // Прогресс выполнения
            ForEach(normalizedTasks) { task in
                let startAngle = startAngle(for: task)
                let progress = task.value * task.progress

                if progress > 0 {
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            task.color,
                            style: StrokeStyle(
                                lineWidth: lineWidth,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(startAngle)
                        .animation(.easeOut, value: task.progress)
                }
            }
        }
        .padding(lineWidth / 2)
    }

    // Расчет начального угла для задачи
    private func startAngle(for task: TaskProgress2) -> Angle {
        guard let index = normalizedTasks.firstIndex(where: { $0.id == task.id }) else {
            return .degrees(-90)
        }

        let precedingValue = normalizedTasks[0..<index].reduce(0) { $0 + $1.value}
//        let separatorsAngeles = 3.0 * Double(normalizedTasks.count)
        let separatorAgle = index * 3
        return .degrees(-90.0 + precedingValue * (360.0) + Double(separatorAgle))
    }
}




struct DemoView2: View {
    @State private var tasks = [
        TaskProgress2(progress: 0.75, color: .blue, name: "Development", value: 0.25),
        TaskProgress2(progress: 0.5, color: .green, name: "Testing", value: 0.25),
        TaskProgress2(progress: 0.9, color: .orange, name: "Design", value: 0.25),
        TaskProgress2(progress: 0.3, color: .purple, name: "Management", value: 0.25)
    ]

    var body: some View {
        VStack(spacing: 30) {
            SegmentedProgressRing2(tasks: tasks, lineWidth: 30)
                .frame(width: 250, height: 250)

            legendView()

            controlButtons()
        }
        .padding()
    }

    // Легенда
    private func legendView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(tasks) { task in
                HStack {
                    Circle()
                        .fill(task.color)
                        .frame(width: 16, height: 16)

                    Text(task.name)
                        .font(.subheadline)

                    Spacer()

                    Text("\(Int(task.progress * 100))%")
                        .font(.system(.body, design: .monospaced))
                        .bold()
                }
            }
        }
        .padding(.horizontal)
    }

    // Кнопки управления
    private func controlButtons() -> some View {
        HStack(spacing: 20) {
            Button("Randomize") {
                withAnimation(.spring) {
                    tasks.indices.forEach {
                        tasks[$0].progress = Double.random(in: 0...1)
                    }
                }
            }

            Button("Reset", role: .destructive) {
                withAnimation(.easeInOut) {
                    tasks.indices.forEach {
                        tasks[$0].progress = 0
                    }
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    DemoView2()
}
