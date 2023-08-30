//
//  AudioDownloadTask.swift
//  
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation

public class AudioDownloadTask: NSObject {
    
    var session:URLSession?
    var dataTask:URLSessionDownloadTask?
    var audioURl = ""
    typealias progressClosure = ((TaskResult) -> Void)
    var downloadAudioCallback: progressClosure!
    
    public func downloadAudio(with url: String) {
        audioURl = url
        if let audioUrl = URL(string: audioURl) {
            let configuration = URLSessionConfiguration.default
            let manqueue = OperationQueue.main
            session = Foundation.URLSession(configuration: configuration, delegate:self, delegateQueue: manqueue)
            dataTask = session?.downloadTask(with: audioUrl)
            dataTask?.resume()
        } else {
            downloadAudioCallback(.failure("InValid URL"))
        }
    }
    
}

extension AudioDownloadTask: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64,
                           totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        //if progress < 1 && progress > 0.0 {
        downloadAudioCallback(.progress(progress))
        // }
    }
    
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL) {
        saveAudioPath(with: location)
    }
}

extension AudioDownloadTask {
    func saveAudioPath(with location: URL) {
        let DocumentDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let destinationUrl = DocumentDirectory.appendingPathComponent(URL(string: audioURl)!.lastPathComponent)
        do {
            try FileManager.default.createDirectory(atPath: DocumentDirectory.path, withIntermediateDirectories: true, attributes: nil)
            print("Dir Path = \(destinationUrl)")
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                downloadAudioCallback(.failure("The file already exists at path"))
            } else {
                do {
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    downloadAudioCallback(.downloaded(destinationUrl))
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        catch let error as NSError {
            downloadAudioCallback(.failure("Unable to create directory \(error.debugDescription)"))
        }
        
    }
}
