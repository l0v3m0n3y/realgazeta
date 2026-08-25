import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public class Realgazeta{
    private let api = "https://realgazeta.com.ua/ghost/api"
    private let key = "9a522231cecde5421b239b663b"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"*/*",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }
    
    public func getContent(contentPath: String) async throws -> Any {
        return try await fetchJSON(from: "\(api)/content/\(contentPath)?key=\(key)&fields=&include=count.posts%2Cfollowers")
    }
    
    public func search(q: String,limit: Int? = 12,page: Int? = 0) async throws -> Any {
        var queryItems = ["search": q,"fields": "id,title,url,slug,custom_excerpt,excerpt","include": "posts,tags,authors,tags.count.posts,tags.count.followers,authors.count.posts,authors.count.followers","key": key]
        
        if let limit = limit {
            queryItems["limit"] = String(limit)
        }
        
        if let page = page {
            queryItems["page"] = String(page)
        }
        
        return try await fetchJSON(from: "\(api)/content/search/all/",queryParameters: queryParameters.isEmpty ? nil : queryParameters)
    }
}
