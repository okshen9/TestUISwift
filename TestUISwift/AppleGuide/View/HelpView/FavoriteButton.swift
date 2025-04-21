//
//  FavoriteButton.swift
//  TestUISwift
//
//  Created by artem on 28.02.2025.
//


import SwiftUI


struct FavoriteButton: View {
    @Binding var isSet: Bool
    var color: Color = .yellow

    var body: some View {
        Button(action: {
            isSet.toggle()
        }, label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? color : .gray)
        })
    }
}


#Preview {
    FavoriteButton(isSet: .constant(true))
}
