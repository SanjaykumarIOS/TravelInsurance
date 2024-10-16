//
//  LottieView.swift
//  TravelInsurance
//
//  Created by SANJAY  on 11/06/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationFileName: String
    let loopMode: LottieLoopMode
   
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)

        ])

        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view when the state changes, if necessary
    }
}



