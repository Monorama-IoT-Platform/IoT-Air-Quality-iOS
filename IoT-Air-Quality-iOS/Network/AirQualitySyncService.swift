final class AirQualitySyncService {
    private let encoder: AirQualitySyncEncoder

    init(encoder: AirQualitySyncEncoder = JSONSyncEncoder()) {
        self.encoder = encoder
    }

    func sync(_ data: [AirQualityData], accessToken: String) async throws {
        let body = try encoder.encode(data)

        var request = URLRequest(url: URL(string: "https://example.com/api/v1/air-quality-data/sync")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        _ = try await URLSession.shared.data(for: request)
    }
}
