//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation
import Combine

@available(macOS 10.15, *)
public class AudioDownloadManagerWrapper: ObservableObject {
    private var downloadManager = AudioDownloadManager()
    private var cancellables = Set<AnyCancellable>()

    @Published var taskResult: TaskResult = .progress(0.0)

    init() {
        downloadManager.downloadAudioCallback = { [weak self] result in
            self?.taskResult = result
        }
    }

    func downloadAudio(with url: String) {
        downloadManager.downloadAudio(with: url)
    }
}
