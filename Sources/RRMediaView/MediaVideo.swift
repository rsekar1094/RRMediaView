//
//  MediaVideo.swift
//  
//
//  Created by Raj S on 31/01/23.
//

import SwiftUI
import AVKit

struct MediaVideo: View {
    
    let source: MediaSource
    
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
        switch mediaSource {
        case .remote(let data):
            VideoPlayer(player: AVPlayer(url: data.url))
        case .local(let data):
            VideoPlayer(player: AVPlayer(url: data.url))
        case .name(let name,let bundle):
            let bundle = bundle ?? Bundle.main
            VideoPlayer(player: AVPlayer(url: bundle.url(forResource: name,
                                                         withExtension: "mp4")!))
        }
    }
    
}
