//
//  SwiftUIView.swift
//  
//
//  Created by Raj S on 04/08/22.
//

import SwiftUI

// MARK: - MediaView
public struct MediaView: View {
    
    // MARK: - Property
    let mediaType: MediaType?
    let placeholder: Placeholder
    let size: Size
    let contentMode: SwiftUI.ContentMode
    let didContentLoaded: ((Any)->Void)?
    
    public init(
        mediaType: MediaType?,
        placeholder: Placeholder = .init(),
        size: Size = .empty,
        contentMode: SwiftUI.ContentMode = .fit,
        didContentLoaded: ((Any)->Void)? = nil
    ) {
        self.mediaType = mediaType
        self.size = size
        self.placeholder = placeholder
        self.contentMode = contentMode
        self.didContentLoaded = didContentLoaded
    }
    
    // MARK: - Body
    public var body: some View {
        switch size {
        case .width(let value):
            content
                .frame(
                    width: value,
                    alignment: .center
                )
        case .height(let value):
            content
                .frame(
                    height: value,
                    alignment: .center
                )
        case .both(let size):
            content
                .frame(
                    width: size.width,
                    height: size.height,
                    alignment: .center
                )
        case .empty:
            content
        }
    }
    
    @ViewBuilder
    var content: some View {
        if let media = self.mediaType {
            getMediaView(media: media)
        } else {
            MediaViewPlaceholder(placeholder: placeholder, placeholderSize: size.placeholderSize)
        }
    }
    
    @ViewBuilder
    func getMediaView(media: MediaType) -> some View {
        switch media {
        case .image(let source):
            MediaImage(
                source: source, 
                placeholderSize: size.placeholderSize,
                placeholder: placeholder,
                contentMode: contentMode,
                didContentLoaded: didContentLoaded
            )
        case .gif(let source):
            MediaAnimatedImage(
                source: source, 
                placeholderSize: size.placeholderSize,
                placeholder: placeholder,
                contentMode: contentMode,
                didContentLoaded: didContentLoaded
            )
        case .lottie(let source):
            LottieView(source: source,frameSize: size.placeholderSize)
        case .video(let source):
            MediaVideo(source: source)
        }
    }
}

struct MediaViewPlaceholder: View {
    let placeholder: MediaView.Placeholder
    let placeholderSize: CGSize?

    var body: some View {
        Text(placeholder.text)
            .foregroundColor(placeholder.textColor)
            .font(.system(size: 16, weight: .medium))
            .frame(width: placeholderSize?.width, height: placeholderSize?.height)
            .background(placeholder.backgroundColor)
            .cornerRadius(placeholder.cornerRadius)
            .overlay {
                RoundedRectangle(cornerRadius: placeholder.cornerRadius)
                    .stroke(placeholder.borderColor)
            }
    }
}

// MARK: - MediaViewModel
public protocol MediaViewModel {
    var mediaType: MediaType? { get }
}

public extension MediaView {
    enum Size {
        case width(CGFloat)
        case height(CGFloat)
        case both(CGSize)
        case empty
    }
}

extension MediaView.Size {
    var placeholderSize: CGSize? {
        switch self {
        case .width(let value):
            return CGSize(width: value, height: value)
        case .height(let value):
            return CGSize(width: value, height: value)
        case .both(let value):
            return value
        case .empty:
            return nil
        }
    }
}


public extension MediaView {
    struct Placeholder {
        let text: String
        let textColor: Color
        let backgroundColor: Color
        let borderColor: Color
        let cornerRadius: CGFloat
        
        public init(
            text: String = "?",
            textColor: Color = .blue,
            backgroundColor: Color = .white,
            borderColor: Color = .gray,
            cornerRadius: CGFloat = 8
        ) {
            self.text = text
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.cornerRadius = cornerRadius
        }
    }
}

public extension String {
    var mediaPlaceholderText: String {
        guard let first = self.first else { return "" }
        return String(first).uppercased()
    }
}


public class MediaUIView: UIView {
    
    private var mediaController: UIHostingController<MediaView>!
    
    public var media: MediaType? {
        didSet {
            removeMediaController()
            setUpMediaController(for: media)
        }
    }
    
    private func setUpMediaController(for media: MediaType?) {
        mediaController = UIHostingController<MediaView>.init(rootView: MediaView(mediaType: media))
        mediaController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mediaController.view)
        
        NSLayoutConstraint.activate([
            mediaController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaController.view.topAnchor.constraint(equalTo: topAnchor),
            mediaController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func removeMediaController() {
        mediaController?.view.removeFromSuperview()
    }
}
