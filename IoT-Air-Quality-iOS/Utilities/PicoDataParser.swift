enum PicoDataParser {
    static func parseSensorData(_ data: Data) -> AirQualityData? {
        guard data.count == 18 else { return nil }

        func getValue(_ offset: Int) -> (Double, Int) {
            let high = Int(data[offset])
            let low = Int(data[offset + 1])
            let level = Int(data[offset + 2])
            let value = Double(high * 256 + low)
            return (value, level)
        }

        let (pm25, _) = getValue(0)
        let (pm10, _) = getValue(3)
        let (tRaw, _) = getValue(6)
        let temperature = tRaw / 10.0
        let (hRaw, _) = getValue(9)
        let humidity = hRaw / 10.0
        let (co2, _) = getValue(12)
        let (voc, _) = getValue(15)

        return AirQualityData(
            pm25: pm25, pm10: pm10, temperature: temperature,
            humidity: humidity, co2: co2, voc: voc,
            collectedAt: ISO8601DateFormatter().string(from: Date()),
            latitude: 37.5665, longitude: 126.9780
        )
    }
}
