//
//  AirQualitySyncService.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/29/25.
//

import Foundation

protocol AirQualitySyncEncoder {
    func encode(_ dataList: AirQualityDataList) throws -> Data
}

struct JSONSyncEncoder: AirQualitySyncEncoder {
    func encode(_ dataList: AirQualityDataList) throws -> Data {
        return try JSONEncoder().encode(dataList)
    }
}

final class AirQualitySyncService {
    private let baseURL = APIConstants.baseURL
    private let encoder: AirQualitySyncEncoder

    init(encoder: AirQualitySyncEncoder = JSONSyncEncoder()) {
        self.encoder = encoder
    }

    func sync(_ data: [AirQualityData], accessToken: String) async throws {
        let dataList = AirQualityDataList(airQualityDataList: data)
        let body = try encoder.encode(dataList)

        guard let url = URL(string: "\(baseURL)/api/v1/air-quality-data/sync") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
