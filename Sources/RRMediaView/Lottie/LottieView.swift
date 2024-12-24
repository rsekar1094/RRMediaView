//
//  LottieView.swift
//  
//
//  Created by Raj S on 09/09/22.
//

import Foundation
import SwiftUI
import Lottie

public struct LottieView: UIViewRepresentable {
 
    let source: MediaSource
    let frameSize: CGSize?
 
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let animationView = LottieAnimationView(frame: .init(origin: .zero, size: frameSize ?? .zero))
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
 
    public func updateUIView(_ view: UIView, context: Context) {
        var mediaSource: MediaSourceData
        if context.environment.colorScheme == .light {
            mediaSource = source.light
        } else {
            mediaSource = source.dark ?? source.light
        }
        
        let animationView = view.subviews.first! as! LottieAnimationView
        switch mediaSource {
        case .remote(let data):
            animationView.setAnimation(
                from: data.url,
                afterSetCompletion: { animationview in
                    Task { @MainActor in
                        animationview.loopMode = .loop
                        animationview.play()
                    }
                }
            )
        case .local(let data):
            animationView.setAnimation(
                from: data.url,
                afterSetCompletion: { animationview in
                    Task { @MainActor in
                        animationview.loopMode = .loop
                        animationview.play()
                    }
                }
            )
        case .name(let name,let bundle):
            animationView.animation = LottieAnimation.named(
                name,
                bundle: bundle ?? .main,
                subdirectory: nil,
                animationCache: nil
            )
            animationView.play()
        }
       
    }
}
