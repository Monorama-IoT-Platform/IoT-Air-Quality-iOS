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

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
