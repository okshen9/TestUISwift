//
//  EventType.swift
//  TestUISwift
//
//  Created by artem on 15.04.2025.
//


import SwiftUI

// Модель данных
enum EventType: String, CaseIterable {
    case meeting = "Встреча"
    case task = "Задача"
    case reminder = "Напоминание"
    
    var title: String { self.rawValue }
}

struct EventTypeCheckpoint: Identifiable {
    let id = UUID()
    let type: EventType
    var isSelected: Bool
}

struct CheckpointsMenu: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @Binding var originalCheckpoints: [EventTypeCheckpoint]
    @State private var tempCheckpoints: [EventTypeCheckpoint] = []
    
    var body: some View {
        Menu {
            ForEach($tempCheckpoints) { $checkpoint in
                Toggle(checkpoint.type.title, isOn: $checkpoint.isSelected)
            }
            
            Divider()
            
            Button("Сохранить", role: .cancel) {
                originalCheckpoints = tempCheckpoints

                dismiss()
                isPresented = false

            }
            .tint(.blue)
            .foregroundStyle(.blue)

            Button(role: .none, action: {}, label: {
                Text("Удалить все")
            })
            .tint(.green)

            Button("Отменить", role: .destructive) {

                dismiss()
//                isPresented = false
            }

            .tint(.blue)
            .foregroundStyle(.blue)
        } label: {
            Label("Фильтры", systemImage: "slider.horizontal.3")
        }
        .onAppear {
            let _ = print("Neshko2")
//            isPresented = true
            tempCheckpoints = originalCheckpoints
        }

//        Menu {
//            Button(action: {print("addCurrentTabToReadingList")}) {
//                Label("Add to Reading List", systemImage: "eyeglasses")
//            }
//            Button(action: {print("bookmarkAll")}) {
//                Label("Add Bookmarks for All Tabs", systemImage: "book")
//            }
//            Button(action: {print("show")}) {
//                Label("Show All Bookmarks", systemImage: "books.vertical")
//            }
//        } label: {
//            Label("Add Bookmark", systemImage: "book")
//        } primaryAction: {
//            addBookmark()
//        }
    }

    func addBookmark() {
        print("addBookmark")
    }
}

struct MenuContentView: View {
    @State private var checkpoints: [EventTypeCheckpoint] = EventType.allCases.map {
        EventTypeCheckpoint(type: $0, isSelected: true)
    }
    @State private var isMenuPresented = true

    var body: some View {
        NavigationStack {
            List(checkpoints) { checkpoint in
                HStack {
                    Text(checkpoint.type.title)
                    Spacer()
                    Image(systemName: checkpoint.isSelected ? "checkmark.circle.fill" : "circle")
                }
                Button(role: .none, action: {}, label: {
                    Text("Удалить все")
                })
                .tint(.red)
//                .foregroundStyle(.red)



                CheckpointsMenu(
                    isPresented: $isMenuPresented,
                    originalCheckpoints: $checkpoints
                )
                .menuStyle(EditingControlsMenuStyle())
            }
            .toolbar {
//                if isMenuPresented {
                    CheckpointsMenu(
                        isPresented: $isMenuPresented,
                        originalCheckpoints: $checkpoints
                    )
                    .menuStyle(EditingControlsMenuStyle())
//                    .menuActionDismissBehavior($isMenuPresented.wrappedValue ? .disabled : .enabled)
//                }
            }
            
        }
    }
}

#Preview {
    MenuContentView()
}

struct EditingControlsMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
    }
}
