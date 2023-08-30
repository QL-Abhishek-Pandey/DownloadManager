//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI
import Combine
import AVKit

class PlayerManager: ObservableObject {
    @Published var isPlay: Bool = false
    @Published var player = AVPlayer()
    
    func playMedia(with url: String) {
        let docDir = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
       
        guard let audioUrl = URL(string: url) else { return }
        let destinationUrl = docDir.appendingPathComponent(audioUrl.lastPathComponent)
        
        do {
                // List the contents of the directory
            let contents = try FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil, options: [])

                // Find the file URL in the directory
                if let fileURL = contents.first(where: { $0 == destinationUrl }) {
                    print("fileURL:",fileURL)
                }
            } catch {
                print("Error reading directory: \(error)")
            }

        
    }
}
