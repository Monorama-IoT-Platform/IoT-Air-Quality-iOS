//
//  ConnectedView.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/29/25.
//

import SwiftUI

struct ConnectedView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = PicoSensorViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // 상단 회색 박스
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Connected Device:")
                            .font(.headline)
                            .foregroundColor(.green)

                        Button("Disconnect") {
                            PicoBLEManager.shared.disconnect()
                            appState.isConnected = false
                            appState.connectedDeviceName = ""
                            appState.connectedDeviceMac = ""
                            appState.nextScreen = .disconnectedMain
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 10) {
                        Text(appState.connectedDeviceName.isEmpty ? "Pico Device" : appState.connectedDeviceName)
                            .font(.body)

                        Text(appState.connectedDeviceMac.isEmpty ? "00:11:22:33:44:55" : appState.connectedDeviceMac)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))

            if let data = viewModel.latestData {
                VStack(spacing: 20) {
                    Text("Real-Time Air Quality")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                        ForEach(generateDataItems(from: data), id: \.label) { item in
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(item.levelColor)
                                    .frame(width: 16, height: 16)

                                Text(item.label)
                                    .font(.subheadline)

                                Text(item.value.components(separatedBy: " ")[0])
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(item.levelColor)

                                Text(item.value.components(separatedBy: " ")[1])
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("측정 중...").foregroundColor(.gray).padding()
                Spacer()
            }

            Spacer()
        }
        .onChange(of: viewModel.latestData) { newValue in
            print("🌀 View에서 데이터 수신됨:", newValue ?? "nil")
        }
        .tabItem {
            Image(systemName: "house")
            Text("Home")
        }
    }
    
    private func generateDataItems(from data: AirQualityData) -> [(label: String, value: String, levelColor: Color)] {
        return [
            ("PM2.5", "\(data.pm25Value) µg/m³", levelColor(for: data.pm25Level)),
            ("PM10", "\(data.pm10Value) µg/m³", levelColor(for: data.pm10Level)),
            ("Temperature", "\(data.temperature) ℃", levelColor(for: data.temperatureLevel)),
            ("Humidity", "\(data.humidity) %", levelColor(for: data.humidityLevel)),
            ("CO₂", "\(data.co2Value) ppm", levelColor(for: data.co2Level)),
            ("VOC", "\(data.vocValue) ppm", levelColor(for: data.vocLevel))
        ]
    }
    
    private func levelColor(for level: Int) -> Color {
        switch level {
        case 0: return .blue
        case 1: return .green
        case 2: return .yellow
        case 3: return .red
        default: return .gray
        }
    }
}

#Preview {
    ConnectedView()
}

//
////
////  ConnectedView.swift
////  IoT-Air-Quality-iOS
////
////  Created by HyungJun Lee on 5/29/25.
//
//import SwiftUI
//
//struct ConnectedView: View {
//    @StateObject private var viewModel = PicoSensorViewModel()
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // 상단 회색 박스
//            VStack(spacing: 10) {
//                HStack(alignment: .top) {
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Connected Device:")
//                            .font(.headline)
//                            .foregroundColor(.green)
//
//                        Button("Disconnect") {
//                            // 연결 끊고 화면 전환 (추후 구현)
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//
//                    Spacer()
//
//                    VStack(alignment: .trailing, spacing: 4) {
//                        Text("Pico Device")
//                            .font(.body)
//
//                        Text("00:11:22:33:44:55")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.gray.opacity(0.2))
//
//            VStack(spacing: 20) {
//                Text("Real-Time Air Quality")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding(.top, 20)
//
//                if let data = viewModel.latestData {
//                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
//                        AirQualityCard(label: "PM2.5", value: data.pm25Value, level: data.pm25Level, unit: "µg/m³")
//                        AirQualityCard(label: "PM10", value: data.pm10Value, level: data.pm10Level, unit: "µg/m³")
//                        AirQualityCard(label: "Temperature", value: data.temperature, level: data.temperatureLevel, unit: "℃")
//                        AirQualityCard(label: "Humidity", value: data.humidity, level: data.humidityLevel, unit: "%")
//                        AirQualityCard(label: "CO₂", value: data.co2Value, level: data.co2Level, unit: "ppm")
//                        AirQualityCard(label: "VOC", value: data.vocValue, level: data.vocLevel, unit: "ppm")
//                    }
//                    .padding()
//                } else {
//                    Text("No data yet")
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//            }
//
//            Spacer()
//        }
//        .onAppear {
//            viewModel.start()
//        }
//        .onDisappear {
//            viewModel.stop()
//        }
//        .tabItem {
//            Image(systemName: "house")
//            Text("Home")
//        }
//    }
//}
//
//struct AirQualityCard: View {
//    let label: String
//    let value: Double
//    let level: Int
//    let unit: String
//
//    var body: some View {
//        let color: Color = (level == 1) ? .green : .red
//
//        VStack(spacing: 8) {
//            Circle()
//                .fill(color)
//                .frame(width: 16, height: 16)
//
//            Text(label)
//                .font(.subheadline)
//
//            Text(String(format: "%.1f", value))
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(color)
//
//            Text(unit)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(radius: 2)
//    }
//}
//
//#Preview {
//    ConnectedView()
//}
