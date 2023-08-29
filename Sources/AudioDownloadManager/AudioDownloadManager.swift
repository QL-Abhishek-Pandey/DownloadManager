import Foundation

class AudioDownloader: NSObject {
    var destinationPath = URL(string: "")
    var totalDownloaded: Float = 0 {
        didSet {
            self.handleDownloadedProgressPercent?(totalDownloaded, destinationPath)
        }
    }
    typealias progressClosure = ((Float, URL?) -> Void)
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
    
    func download(url: String, progress: ((Float, URL?) -> Void)?) {
        self.handleDownloadedProgressPercent = progress
        guard let url = URL(string: url) else {
            preconditionFailure("URL is invalid!")
        }
        
        let task = session.downloadTask(with: url)
        task.resume()
    }
    
}

extension AudioDownloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        self.totalDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        destinationPath = location
      
    }
}
