//
//  MediaType.swift
//
//
//  Created by Raj S on 14/03/24.
//

import Foundation

// MARK: - MediaType
/// Media will hold different media and it's source which can be shown in the UI
public enum MediaType {
    
    /// Holds the image source information
    case image(MediaSource)
    
    /// Holds the gif source information
    case gif(MediaSource)
    
    /// Holds the lottie source information
    case lottie(MediaSource)
    
    /// Holds the video source information
    case video(MediaSource)
}

// MARK: - MediaSource

/// MediaSource will holds the information of where we need to read/download the media from
public enum MediaSourceData: Equatable {
    
    /// Selected media is available on remote and this holds it's remote url
    case remote(MediaSourceURL)
    
    /// Selected media is available on local file storage and holds it's local filemanager url
    case local(MediaSourceURL)
    
    /// Name of the resource - for example for image - UIImage(named: "<Value>")
    case name(String, Bundle?)
    
    
    private var equatableId: String {
        switch self {
        case .remote(let data):
            return "remote-"+data.url.absoluteString
        case .local(let data):
            return "local-"+data.url.absoluteString
        case .name(let data, _):
            return data
        }
    }
    
    public static func == (lhs: MediaSourceData, rhs: MediaSourceData) -> Bool {
        return lhs.equatableId == rhs.equatableId
    }
    
}

public extension MediaType {
    var source: MediaSource {
        switch self {
        case .image(let mediaSource),
                .gif(let mediaSource),
                .lottie(let mediaSource),
                .video(let mediaSource):
            return mediaSource
        }
    }
}


public struct MediaSource {
    public let light: MediaSourceData
    public let dark: MediaSourceData?
    
    public init(light: MediaSourceData, dark: MediaSourceData?) {
        self.light = light
        self.dark = dark
    }
}

public extension MediaSource {
    static func remote(_ url: MediaSourceURL) -> MediaSource {
        return .init(light: .remote(url), dark: nil)
    }
    
    static func local(_ url: MediaSourceURL) -> MediaSource {
        return .init(light: .local(url), dark: nil)
    }
    
    static func name(_ name: String, _ bundle: Bundle?) -> MediaSource {
        return .init(light: .name(name, bundle), dark: nil)
    }
}

public protocol MediaSourceURL {
    var url: URL { get }
    var cacheKey: String { get }
}
