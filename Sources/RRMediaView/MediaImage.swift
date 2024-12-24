import SwiftUI
import Kingfisher


// MARK: - MediaImage
struct MediaImage: View {
    
    let source: MediaSource
    let placeholderSize: CGSize?
    let placeholder: MediaView.Placeholder
    let contentMode: SwiftUI.ContentMode
    let didContentLoaded: ((Any)->Void)?
    
    @State
    private var hasError: Bool = false
    
    @Environment(\.colorScheme)
    private var colorScheme
    
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
            KFImage(
                source: .network(
                    KF.ImageResource(
                        downloadURL: data.url,
                        cacheKey: data.cacheKey
                    )
                )
            )
            .resizable()
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
            .onFailure { _ in
                hasError = true
            }
            .aspectRatio(contentMode: contentMode)
        case .local(let data):
            KFImage(data.url)
                .resizable()
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


struct CircularLoader: View {
    
    @State
    private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(.blue)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear() {
                    self.isAnimating = true
                }
        }
    }
}
