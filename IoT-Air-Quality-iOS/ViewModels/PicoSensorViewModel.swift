import Foundation
import Combine

final class PicoSensorViewModel: ObservableObject {
    @Published var latestData: AirQualityData?
    private var cancellables = Set<AnyCancellable>()

    init() {
        PicoBLEManager.shared.delegate = self
    }

    func start() {
        // BLE 연결 자동 시작됨 (init 시)
    }

    private func sendToServer(_ data: AirQualityData) {
        Task {
            do {
                let accessToken = TokenManager.shared.getAccessToken() ?? ""
                try await AirQualityAPIService.shared.sendSensorData(data, accessToken: accessToken)
                print("✅ 센서 데이터 전송 완료")
            } catch {
                print("❌ 서버 전송 실패: \(error)")
            }
        }
    }
}

extension PicoSensorViewModel: PicoBLEManagerDelegate {
    func didReceiveSensorData(_ data: AirQualityData) {
        DispatchQueue.main.async {
            self.latestData = data
        }
        sendToServer(data)
    }
}
