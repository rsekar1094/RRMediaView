//
//  MediaAnimatedImage.swift
//
//
//  Created by Raj S on 31/01/23.
//

import SwiftUI
import Kingfisher

// MARK: - MediaImage
struct MediaAnimatedImage: View {
    
    let source: MediaSource
    let placeholderSize: CGSize?
    let placeholder: MediaView.Placeholder
    let contentMode: SwiftUI.ContentMode
    let didContentLoaded: ((Any)->Void)?
    
    @Environment(\.colorScheme) 
    private var colorScheme
    
    @State
    private var hasError: Bool = false
    
    var mediaSource: MediaSourceData {
        if colorScheme == .light {
            return source.light
        } else {
            return source.dark ?? source.light
        }
    }
    
    var body: some View {
        if hasError {
            content
                .overlay {
                    MediaViewPlaceholder(
                        placeholder: placeholder,
                        placeholderSize: placeholderSize
                    )
                }
        } else {
            content
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch mediaSource {
        case .remote(let data):
            KFAnimatedImage(
                data.url
            )
            .configure { imageView in
                imageView.repeatCount = .finite(count: 30)
                imageView.startAnimating()
            }
            .fade(duration: 0.15)
            .placeholder { p in
                if !hasError {
                    let size = getLoaderSize()
                    CircularLoader()
                        .frame(
                            width: size.width,
                            height: size.height,
                            alignment: .center
                        )
                }
            }
            .onSuccess { result in
                didContentLoaded?(result.image)
                hasError = false
            }
            .onFailure { error in
                hasError = true
            }
            .aspectRatio(contentMode: contentMode)
        case .local(let data):
            KFAnimatedImage(data.url)
                .onSuccess { result in
                    didContentLoaded?(result.image)
                }
                .aspectRatio(contentMode: contentMode)
        case .name(let name,let bundle):
            Image(name,bundle: bundle)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .onAppear {
                    didContentLoaded?(
                        UIImage.init(
                            named: name,
                            in: bundle,
                            with: nil
                        )!
                    )
                }
        }
    }
    
    private func getLoaderSize() -> CGSize {
        guard let placeholderSize else { return CGSize(width: 40, height: 40) }
        
        let size = min(placeholderSize.width, placeholderSize.height)
        var preferrableSize =  min(size * 0.5, 50)
        
        if preferrableSize < 10 {
            preferrableSize = 10
        }
    
        return CGSize(width: preferrableSize, height: preferrableSize)
    }
    
}
