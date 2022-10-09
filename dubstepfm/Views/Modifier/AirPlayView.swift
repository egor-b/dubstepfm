//
//  AirPlayViewRepresentable.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 10/7/22.
//

import SwiftUI
import AVKit

struct AirPlayView: View {
    var body: some View {
        AirPlayViewRepresentable()
    }
}

struct AirPlayViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        AirPlayView()
    }
}

struct AirPlayViewRepresentable: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let airPlayPickerView = AVRoutePickerView()
        airPlayPickerView.backgroundColor = .clear
        airPlayPickerView.activeTintColor = .systemBlue
        return airPlayPickerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
}
