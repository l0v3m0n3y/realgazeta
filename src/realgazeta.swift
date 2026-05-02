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
    
    public func get_content(content_path: String) async throws -> Any {
        let urlString = "\(api)/content/\(content_path)?key=\(key)&fields=&include=count.posts%2Cfollowers"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func search(q: String,limit: Int? = 12,page: Int? = 0) async throws -> Any {
        var components = URLComponents(string: "\(api)/content/search/all/")
        var queryItems = [
        URLQueryItem(name: "search", value: q),
        URLQueryItem(name: "fields", value: "id,title,url,slug,custom_excerpt,excerpt"),
        URLQueryItem(name: "include", value: "posts,tags,authors,tags.count.posts,tags.count.followers,authors.count.posts,authors.count.followers"),
        URLQueryItem(name: "key", value: key)
        ]
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        if let page = page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        components?.queryItems = queryItems
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
}
