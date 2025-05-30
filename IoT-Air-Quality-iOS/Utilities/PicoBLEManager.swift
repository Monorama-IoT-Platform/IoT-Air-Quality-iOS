//
//  PicoBLEManagerDelegate.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/29/25.
//


import CoreBluetooth

protocol PicoBLEManagerDelegate: AnyObject {
    func didReceiveSensorData(_ data: AirQualityData)
}

final class PicoBLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = PicoBLEManager()
    private var centralManager: CBCentralManager!
    private var picoPeripheral: CBPeripheral?

    weak var delegate: PicoBLEManagerDelegate?

    private let sensorUUID = CBUUID(string: "0000FFB3-0000-1000-8000")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name?.contains("Bandi-Pico") == true {
            picoPeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics([sensorUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for char in characteristics where char.uuid == sensorUUID {
            peripheral.setNotifyValue(true, for: char)
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        if let parsed = PicoDataParser.parseSensorData(data) {
            delegate?.didReceiveSensorData(parsed)
        }
    }
}
