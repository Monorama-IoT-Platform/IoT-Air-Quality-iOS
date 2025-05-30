struct ParsedSensorData {
    let pm25: Double
    let pm10: Double
    let temperature: Double
    let humidity: Double
    let co2: Double
    let voc: Double
    let levels: [Int] // 각 항목별 level: [pm25Level, pm10Level, tempLevel, ...]
}
