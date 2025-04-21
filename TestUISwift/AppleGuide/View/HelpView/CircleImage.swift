//
//  CircleImage 2.swift
//  TestUISwift
//
//  Created by artem on 27.02.2025.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable(resizingMode: .stretch)
            .frame(width: 300, height: 300)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.red, lineWidth: 10)
            }
            .shadow(radius: 7)
            
    }
}


#Preview {
    CircleImage(image: Image("turtlerock"))
}
