//
//  File.swift
//  
//
//  Created by Raj S on 09/09/22.
//

import Foundation
import Lottie

extension LottieAnimationView {
    func setAnimation(
        from url: URL?,
        cacheProvider: LottieFileProviding = LottieFileProvider.shared,
        afterSetCompletion: @escaping @Sendable (LottieAnimationView) -> Void
    ) {
        guard let url = url else { return }
        
        /// 1
        if let animation = cacheProvider.animation(forKey: url.absoluteString) {
            self.animation = animation
            afterSetCompletion(self)
            return
        }
        
        /// 2
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, error == nil, let jsonData = data else {
                return
            }
            do {
                let animation = try JSONDecoder().decode(LottieAnimation.self, from: jsonData)
                /// 3
                cacheProvider.setAnimationData(jsonData, forKey: url.absoluteString)
                DispatchQueue.main.async {
                    self.animation = animation
                    afterSetCompletion(self)
                }
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

