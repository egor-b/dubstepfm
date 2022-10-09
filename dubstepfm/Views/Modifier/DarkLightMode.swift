//
//  ColorSchemeHandler.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 10/8/22.
//

import SwiftUI

struct DarkLightForegroundColor: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .dark ? .white : .black)
    }
    
}

extension View {
    func darkLightForegroundColor() -> some View {
        return self.modifier(DarkLightForegroundColor())
    }
}
