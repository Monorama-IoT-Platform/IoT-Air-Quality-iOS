import Foundation
import Combine
import CoreLocation

final class PicoSensorViewModel: ObservableObject {
    @Published var latestData: AirQualityData?

    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        let locationPublisher = locationManager.$currentLocation
            .compactMap { $0?.coordinate }
            .handleEvents(receiveOutput: { coord in
                print("📍 위치 업데이트 수신됨:", coord)
            })

        let sensorPublisher = PicoBLEManager.shared.dataPublisher
            .handleEvents(receiveOutput: { data in
                print("🔬 BLE 센서 수신됨:", data)
            })

        // 위치와 센서 데이터를 결합하여 주기적으로 서버 전송
        Publishers.CombineLatest(locationPublisher, sensorPublisher)
            .throttle(for: .seconds(3), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] (coordinate, parsed) in
                self?.handleSensorData(parsed, coordinate: coordinate)
            }
            .store(in: &cancellables)
    }

    private func handleSensorData(_ parsed: ParsedSensorData, coordinate: CLLocationCoordinate2D) {
        let data = AirQualityData(
            createdAt: Date().formattedString(),
            pm25Value: parsed.pm25,
            pm25Level: parsed.levels[0],
            pm10Value: parsed.pm10,
            pm10Level: parsed.levels[1],
            temperature: parsed.temperature,
            temperatureLevel: parsed.levels[2],
            humidity: parsed.humidity,
            humidityLevel: parsed.levels[3],
            co2Value: parsed.co2,
            co2Level: parsed.levels[4],
            vocValue: parsed.voc,
            vocLevel: parsed.levels[5],
            picoDeviceLatitude: coordinate.latitude,
            picoDeviceLongitude: coordinate.longitude
        )
        
        print("📡 수신된 센서 데이터:", data)

        DispatchQueue.main.async {
            self.latestData = data
        }

        sendToServer(data)
    }

    private func sendToServer(_ data: AirQualityData) {
        Task {
            do {
                let accessToken = TokenManager.shared.getAccessToken() ?? ""
                
                // 🔍 전송 전 JSON 확인
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let jsonData = try? encoder.encode(data),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("🚀 서버 전송 JSON:\n\(jsonString)")
                }
                
                try await AirQualityAPIService.shared.sendSensorData(data, accessToken: accessToken)
                print("✅ 센서 데이터 전송 완료")
            } catch {
                print("❌ 서버 전송 실패: \(error)")
                // TODO: 실패 시 로컬 저장 로직 추가 예정
            }
        }
    }
}
