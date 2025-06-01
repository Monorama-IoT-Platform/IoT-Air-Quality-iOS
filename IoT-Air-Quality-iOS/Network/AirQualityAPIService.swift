//
//  AirQualityAPIService.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/29/25.
//

import Foundation

final class AirQualityAPIService {
    static let shared = AirQualityAPIService()
    private let baseURL = APIConstants.baseURL

    func sendSensorData(_ data: AirQualityData, accessToken: String) async throws {
        guard let url = URL(string: "\(baseURL)/api/v1/air-quality-data/realtime") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(data)

        let (responseData, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode != 200 {
            let body = String(data: responseData, encoding: .utf8) ?? ""
            print("⚠️ 전송 실패: \(body)")
            throw URLError(.cannotConnectToHost)
        }

        // 성공 응답 로그 출력
        if let json = try? JSONSerialization.jsonObject(with: responseData) {
            print("✅ 전송 성공 응답: \(json)")
        }
    }
}
