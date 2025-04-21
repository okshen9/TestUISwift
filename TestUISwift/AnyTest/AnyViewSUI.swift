//
//  AnyViewSUI.swift
//  TestUISwift
//
//  Created by artem on 15.04.2025.
//

import SwiftUI
import Charts

struct AnyViewSUI: View {
    var array = ["sdfsdf", "sdfsdfsd2", "sdfsdfsd3", "sdfsdfsd4"]
    @State var selectedValue: String?

    @State private var selectedObjectBorders = [
        Border(color: .green, thickness: .thin),
        Border(color: .red, thickness: .thick)
    ]

    var body: some View {
//        Text("ContextMenu")
        Text("Turtle Rock")
            .contextMenu(menuItems)


        Gauge(value: 0.4, label: {Text("Xnj-nj")})


        Picker("Picker", selection: $selectedValue, content: {
            ForEach(array, id: \.self) { item in
                Text(item).tag(item)
            }
        })

        Picker(
            "Border Thickness",
            sources: $selectedObjectBorders,
            selection: \.thickness
        ) {
            ForEach(Thickness.allCases) { thickness in
                Text(thickness.rawValue)
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selectedObjectBorders.first?.color ?? Color.blue,
                        lineWidth: selectedObjectBorders.first?.thickness.width ?? 0)
        )
    }

    @State private var shouldShowMenu = true
    private let menuItems = ContextMenu {
        Button {
            // Add this item to a list of favorites.
        } label: {
            Label("Add to Favorites", systemImage: "heart")
        }
        Button {
            // Open Maps and center it on this item.
        } label: {
            Label("Show in Maps", systemImage: "mappin")
        }
    }
}

#Preview {
    AnyViewSUI()
}


enum Thickness: String, CaseIterable, Identifiable {
    case thin
    case regular
    case thick

    var width: CGFloat {
        switch self {
        case .thin:
            return 1
        case .regular:
            return 2
        case .thick:
            return 4
        }
    }


    var id: String { rawValue }
}


struct Border {
    var color: Color
    var thickness: Thickness
}
