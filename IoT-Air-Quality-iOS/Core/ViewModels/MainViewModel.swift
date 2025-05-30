////
////  MainViewModel.swift
////  IoT-Air-Quality-iOS
////
////  Created by HyungJun Lee on 5/21/25.
////
//
//import Foundation
//import SwiftUI
//
//@MainActor
//final class MainViewModel: ObservableObject {
//    @Published var isConnected: Bool = false
//    @Published var deviceName: String = ""
//    @Published var deviceAddress: String = ""
//    @Published var showScanModal: Bool = false
//    @Published var errorMessage: String?
//
//    // 실시간 센서값
//    @Published var pm25Value: Double?
//    @Published var pm10Value: Double?
//    @Published var temperature: Double?
//    @Published var humidity: Double?
//    @Published var co2Value: Double?
//    @Published var vocValue: Double?
//    
//    // 연결된 장비 주소
//    @Published var connectedAddress: String?
//    
//    // BLE 스캔 결과 리스트
//    @Published var scanResults: [ScannedDevice] = []
//    struct ScannedDevice {
//        let name: String
//        let address: String
//    }
//
//    func start() {
//        // BLEService에 delegate 연결 등 초기 설정 가능
//    }
//
//    func toggleConnection() {
//        if isConnected {
//            BLEService.shared.disconnect()
//            isConnected = false
//            deviceName = ""
//            deviceAddress = ""
//        } else {
//            showScanModal = true
//        }
//    }
//
//    // ✅ 센서 항목별 색상 판단 로직
//    func valueColor(for title: String, value: Double) -> Color {
//        switch title {
//        case "PM2.5":
//            return value <= 15 ? .green : .red
//        case "PM10":
//            return value <= 30 ? .green : .red
//        case "Temperature":
//            return (18...28).contains(value) ? .green : .orange
//        case "Humidity":
//            return (30...60).contains(value) ? .green : .blue
//        case "CO2":
//            if value <= 800 { return .green }
//            else if value <= 1000 { return .yellow }
//            else { return .red }
//        case "VOC":
//            return value <= 0.5 ? .green : .red
//        default:
//            return .gray
//        }
//    }
//
//    // 👉 BLE 장비 선택 시 호출
//    func connectToDevice(name: String, address: String) {
//        self.deviceName = name
//        self.deviceAddress = address
//        self.connectedAddress = address
//        self.isConnected = true
//        self.showScanModal = false
//    }
//
//    // 👉 BLEService에서 수신한 데이터 처리
//    func updateSensorValues(from data: AirQualityData) {
//        self.pm25Value = data.pm25
//        self.pm10Value = data.pm10
//        self.temperature = data.temperature
//        self.humidity = data.humidity
//        self.co2Value = data.co2
//        self.vocValue = data.voc
//    }
//    
//    
//
//    func startScanning() {
//        scanResults = []
//        BLEService.shared.startScanning()
//    }
//
//    func stopScanning() {
//        BLEService.shared.stopScanning()
//    }
//}
//
//extension MainViewModel: BLEServiceDelegate {
//    func didDiscoverDevice(name: String, address: String) {
//        let device = ScannedDevice(name: name, address: address)
//        if !scanResults.contains(where: { $0.address == address }) {
//            scanResults.append(device)
//        }
//    }
//
//    func didConnectToDevice(name: String) {
//        self.deviceName = name
//        self.isConnected = true
//    }
//
//    func didDisconnectFromDevice() {
//        self.isConnected = false
//        self.deviceName = ""
//        self.deviceAddress = ""
//        self.connectedAddress = nil
//    }
//
//    func didReceiveData(_ data: Data) {
//        // 추후: updateSensorValues()
//    }
//}
