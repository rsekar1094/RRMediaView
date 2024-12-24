//
//  ContentView.swift
//  RRMediaPickerDemo
//
//  Created by Raj S on 24/12/24.
//

import SwiftUI
import RRMediaView
import AVKit

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                
                Section {
                    Text("Image")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    MediaView(
                        mediaType: .image(.name("pizza", nil))
                    )
                    
                    MediaView(
                        mediaType: .image(
                            .remote(URL(string: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U")!)
                        )
                    )
                }
                
                Section {
                    Text("Video")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    MediaView(
                        mediaType: .video(
                            .remote(URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
                                   )
                        )
                    )
                    .frame(height: 400)
                    
                    MediaView(
                        mediaType: .video(.name("ForBiggerBlazes", .main))
                    )
                    .frame(height: 400)
                }
                
                
                Section {
                    Text("Gif")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    MediaView(
                        mediaType: .gif(
                            .remote(URL(string: "https://media1.tenor.com/m/Ps_NnXFTyRYAAAAd/send-link-send.gif")!)
                        )
                    )
                }
                
                
                
                Section {
                    Text("Lottie")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    MediaView(mediaType: .lottie(.name("lottie-sample", nil)))
                        .frame(height: 400)
                }
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

extension URL: @retroactive MediaSourceURL {
    public var url: URL {
        return self
    }
    
    public var cache: String {
        return self.absoluteString
    }
}
