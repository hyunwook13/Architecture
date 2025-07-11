//
//  APIClient.swift
//  MVVM
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

import RxSwift
import RxCocoa

let clientID = "Spotify ID를 입력해주세요"
let clientSecret = "Spotify Sceret을 입력해주세요"

protocol ServiceType {
    func getImage(with urlStr: String?, size: CGSize) -> Single<UIImage>
    func fetchAlbums() -> Single<BrowseNewReleasesResponse>
}

enum TokenError: Error, CustomDebugStringConvertible {
    case invalidURL
    case badResponse(statusCode: Int)
    case noData
    case decodingError(Error)
    
    var debugDescription: String {
        switch self {
        case .badResponse(let code): return "badResponse with \(code)"
        case .decodingError(let err): return "decodingError with \(err.localizedDescription)"
        case .invalidURL: return "invalidURL"
        case .noData: return "noData"
        }
    }
}

final class APIClient: ServiceType {
    static let shared = APIClient()
    private init() {}
    
    private let baseURL = URL(string: "https://api.spotify.com/v1")!
    private var token: String?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Public API
    
    func fetchAlbums() -> Single<BrowseNewReleasesResponse> {
        return ensureToken()
            .flatMap { [unowned self] token in
                self.perform(
                    path: "browse/new-releases",
                    decodeAs: BrowseNewReleasesResponse.self
                )
            }
    }
    
    func getImage(with urlString: String?, size: CGSize = CGSize(width: 60, height: 60)) -> Single<UIImage> {
        guard
            let str = urlString,
            let url = URL(string: str)
        else {
            return .error(TokenError.invalidURL)
        }
        
        if let cached = ImageCache.shared.image(for: str, size: size) {
            return .just(cached)
        }
        
        return Single<UIImage>.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let http = response as? HTTPURLResponse,
                      (200..<300).contains(http.statusCode),
                      let data = data,
                      let img = UIImage.downsampledImage(from: data, to: size) else {
                    single(.failure(TokenError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)))
                    return
                }
                
                ImageCache.shared.insert(img, for: str, size: size)
                single(.success(img))
            }
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
    // MARK: - Helpers
    
    private func ensureToken() -> Single<String> {
        if let token = self.token {
            return .just(token)
        } else {
            return fetchAccessToken().do(onSuccess: { [weak self] newToken in
                self?.token = newToken
            })
        }
    }
    
    private func fetchAccessToken() -> Single<String> {
        guard let url = URL(string: "https://accounts.spotify.com/api/token") else {
            return .error(TokenError.invalidURL)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
        req.httpBody = Data(body.utf8)
        
        return URLSession.shared.rx.response(request: req)
            .map { response, data in
                guard (200..<300).contains(response.statusCode) else {
                    throw TokenError.badResponse(statusCode: response.statusCode)
                }
                let decoded = try JSONDecoder().decode(Token.self, from: data)
                return decoded.access_token
            }.asSingle()
    }
    
    
    private func perform<T: Decodable>(
        path: String,
        method: String = "GET",
        body: Data? = nil,
        decodeAs type: T.Type
    ) -> Single<T> {
        guard let token = token else {
            return .error(TokenError.noData)
        }
        
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        req.httpMethod = method
        req.httpBody = body
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.rx.response(request: req)
            .map { response, data in
                guard (200..<300).contains(response.statusCode) else {
                    throw TokenError.badResponse(statusCode: response.statusCode)
                }
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw TokenError.decodingError(error)
                }
            }.asSingle()
    }
}
