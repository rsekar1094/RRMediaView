//
//  File.swift
//  
//
//  Created by Raj S on 09/09/22.
//

import Foundation
import Lottie

protocol LottieFileProviding: AnyObject, Sendable {
    func animation(forKey: String) -> LottieAnimation?
    func setAnimationData(_ data: Data, forKey: String)
}

final class LottieFileProvider: LottieFileProviding {
    static let shared = LottieFileProvider()
    
    private let urlBuilder: LottieFileURLBuilding
    
    init(urlBuilder: LottieFileURLBuilding = LottieFileURLBuilder()) {
        self.urlBuilder = urlBuilder
    }
    
    /// 1
    func animation(forKey: String) -> LottieAnimation? {
        do {
            let path = urlBuilder.buildPath(for: forKey)
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode(LottieAnimation.self, from: data)
        } catch {
            return nil
        }
    }
    
    /// 2
    func setAnimationData(_ data: Data, forKey: String) {
        do {
            let path = urlBuilder.buildPath(for: forKey)
            let directory = urlBuilder.directory
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            try data.write(to: path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 3
    func clearCache() {
        do {
            let url = urlBuilder.directory
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}


////// URL Builder
protocol LottieFileURLBuilding: AnyObject, Sendable {
    var directory: URL { get }
    func buildPath(for key: String) -> URL
}

final class LottieFileURLBuilder: LottieFileURLBuilding {
    private enum Constant {
        static let lottieDirectory = "lottie-animations"
    }
        
    private let filesDirectory: URL
    
   let directory: URL
    
    /// 4
    func buildPath(for key: String) -> URL {
        let url = URL(string: key)
        let fileExtension = url?.pathExtension ?? "json"
        let fileName = url?.deletingPathExtension().lastPathComponent ?? ""
        return directory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }
    
    public init() {
        let filesDirectory: URL
        do {
            filesDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            filesDirectory = URL(fileURLWithPath: "files")
        }
        
        self.directory = filesDirectory.appendingPathComponent(Constant.lottieDirectory)
        self.filesDirectory = filesDirectory
    }
}
