//  ConnectedView.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/29/25.

import SwiftUI

struct ConnectedView: View {
    let deviceName = "Pico Device 1"
    let macAddress = "00:11:22:33:44:55"

    let airQualityData: [(label: String, value: String, levelColor: Color)] = [
        ("PM2.5", "10.1 µg/m³", .green),
        ("PM10", "20.5 µg/m³", .green),
        ("Temperature", "23.4 ℃", .green),
        ("Humidity", "45.6 %", .green),
        ("CO₂", "400.5 ppm", .green),
        ("VOC", "0.02 ppm", .green)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // 상단 회색 박스
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Connected Device:")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text(deviceName)
                            .font(.body)
                        Text(macAddress)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button("Disconnect") {
                        // 연결 끊고 화면 전환 (추후 구현)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))

            VStack(spacing: 20) {
                Text("Real-Time Air Quality")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                    ForEach(airQualityData, id: \.(label)) { item in
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

            Spacer()
        }
        .tabItem {
            Image(systemName: "house")
            Text("Home")
        }
    }
}

#Preview {
    ConnectedView()
}
