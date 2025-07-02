//
//  APIClient.swift
//  MVVM
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

let clientID = "Spotify ID를 입력해주세요"
let clientSecret = "Spotify Sceret을 입력해주세요"

enum TokenError: Error, CustomDebugStringConvertible {
    case invalidURL
    case badResponse(statusCode: Int)
    case noData
    case decodingError(Error)
    
    var debugDescription: String {
        switch self {
        case .badResponse(let statusCode):
            return "badResponse with \(statusCode)"
        case .decodingError(let error):
            return "decodingError with \(error.localizedDescription)"
        case .invalidURL:
            return "invalidURL"
        case .noData:
            return "noData"
        }
    }
}

final class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let baseURL = URL(string: "https://api.spotify.com/v1")!
    private var token: String?
    
    func fetchAlbums() async throws -> BrowseNewReleasesResponse {
        return try await perform(
            path: "browse/new-releases",
            decodeAs: BrowseNewReleasesResponse.self
        )
    }
    
    func getImage(with urlString: String?, size: CGSize = .init(width: 60, height: 60)) async throws -> UIImage {
        guard
            let str = urlString,
            let url = URL(string: str)
        else { throw TokenError.invalidURL }
        
        if let cached = ImageCache.shared.image(for: str, size: size) {
            return cached
        }
        
        do {
            let (data, resp) = try await URLSession.shared.data(from: url)
            guard
                let http = resp as? HTTPURLResponse,
                (200..<300).contains(http.statusCode),
                let img = UIImage.downsampledImage(from: data, to: size)
            else {
                throw TokenError.badResponse(statusCode: -1)
            }
            ImageCache.shared.insert(img, for: str, size: size)
            return img
        } catch {
            throw error
        }
    }
    
    private func fetchAccessToken() async throws -> String {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
        req.httpBody = Data(body.utf8)
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw TokenError.badResponse(statusCode: (resp as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        let tokenWrapper = try JSONDecoder().decode(Token.self, from: data)
        return tokenWrapper.access_token
    }
    
    // 공통 요청 수행 헬퍼
    private func perform<T: Decodable>(
        path: String,
        method: String = "GET",
        body: Data? = nil,
        decodeAs type: T.Type
    ) async throws -> T {
        let url = baseURL.appendingPathComponent(path)
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 토큰이 없으면 한번 가져오기
        if token == nil {
            token = try await fetchAccessToken()
        }
        req.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw TokenError.badResponse(statusCode: (resp as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
