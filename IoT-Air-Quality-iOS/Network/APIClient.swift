//
//  APIClient.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/21/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case unauthorized
    case unknown(Error)
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = APIConstants.baseURL // 실제 도메인으로 교체

    func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        headers: [String: String] = [:],
        responseType: T.Type,
        retry: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        // AccessToken 설정
        if let token = TokenManager.shared.getAccessToken() {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(statusCode: -1)
            }

            if httpResponse.statusCode == 401 && retry {
                let refreshed = await withCheckedContinuation { continuation in
                    AuthService.shared.refreshAccessToken { success in
                        continuation.resume(returning: success)
                    }
                }
                if refreshed {
                    return try await APIClient.shared.request(
                        endpoint: endpoint,
                        method: method,
                        body: body,
                        headers: headers,
                        responseType: responseType,
                        retry: false
                    )
                } else {
                    throw APIError.unauthorized
                }
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.requestFailed(statusCode: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.decodingFailed
            }
        } catch {
            throw APIError.unknown(error)
        }
    }
}
