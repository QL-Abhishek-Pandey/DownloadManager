//
//  AudioDownloadTask.swift
//  
//
//  Created by Abhishek Pandey on 29/08/23.
//

import Foundation
import UserNotifications

public class AudioDownloadTask: NSObject {
    
    //MARK: - Properties
    var session:URLSession?
    var dataTask:URLSessionDownloadTask?
    var audioURl = ""
    typealias progressClosure = ((TaskResult) -> Void)?
    var downloadAudioCallback: progressClosure!
    
    //MARK: Download Media
    public func downloadMedia(with url: String) {
        audioURl = url
        if let audioUrl = URL(string: audioURl) {
            let configuration = URLSessionConfiguration.default
            let manqueue = OperationQueue.main
            session = Foundation.URLSession(configuration: configuration, delegate:self, delegateQueue: manqueue)
            dataTask = session?.downloadTask(with: audioUrl)
            dataTask?.resume()
        } else {
            downloadAudioCallback?(.failure("InValid URL"))
        }
    }
    
    //MARK: Cancel Download Media
    func cancelMedia() {
        dataTask?.cancel()
        downloadAudioCallback?(.cancel)
    }
    
}

//MARK: - URLSessionDownloadDelegate
extension AudioDownloadTask: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64,
                           totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        downloadAudioCallback?(.progress(progress))
    }
    
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL) {
        saveAudioPath(with: location)
    }
}

extension AudioDownloadTask {
    //MARK: -  Save AudioFile in DIR
    func saveAudioPath(with location: URL) {
        let DocumentDirectory = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        guard let audioUrl = URL(string: audioURl) else { return }
        let destinationUrl = DocumentDirectory.appendingPathComponent(audioUrl.lastPathComponent)
        
        do {
            try FileManager.default.createDirectory(atPath: DocumentDirectory.path, withIntermediateDirectories: true, attributes: nil)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path){
                // check this url is already exist or not
                try? FileManager.default.removeItem(at: destinationUrl)
            }
            do {
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                triggerLocalNotification()
                downloadAudioCallback?(.downloaded(destinationUrl))
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        catch let error as NSError {
            downloadAudioCallback?(.failure("Unable to create directory \(error.debugDescription)"))
        }
        
    }
    
    //MARK: - Remove Media
    func removeMedia(with url: String) {
        let docDir = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        guard let audioUrl = URL(string: url) else { return }
        let destinationUrl = docDir.appendingPathComponent(audioUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            try? FileManager.default.removeItem(at: destinationUrl)
            downloadAudioCallback?(.deleted(audioUrl))
        }
    }
}


extension AudioDownloadTask {
    //MARK: - triggerLocalNotification
    func triggerLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download"
        content.subtitle = "Audio is downloaded"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
