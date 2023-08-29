import Foundation

public class AudioDownloader: NSObject {
    var destinationPath = URL(string: "")
    var totalDownloaded: Float = 0
    typealias progressClosure = ((TaskResult) -> Void)
    var handleDownloadedProgressPercent: progressClosure!
    
    // MARK: - Properties
    private var configuration: URLSessionConfiguration
    private lazy var session: URLSession = {
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        
        return session
    }()
    
    // MARK: - Initialization
    override init() {
        self.configuration = URLSessionConfiguration.background(withIdentifier: "backgroundTasks")
        super.init()
    }
    
    func download(url: String, progress: ((TaskResult) -> Void)?) {
        if let url = URL(string: url) {
            let task = session.downloadTask(with: url)
            task.resume()
        } else {
            handleDownloadedProgressPercent(.failure("URL is invalid"))
        }
    }
    
}

extension AudioDownloader: URLSessionDownloadDelegate {
   public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        self.totalDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if totalDownloaded < 1 && totalDownloaded > 0.0 {
        handleDownloadedProgressPercent(.progress(totalDownloaded))
        }
    }
    
 public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        handleDownloadedProgressPercent(.downloaded(location))
      
    }
}
