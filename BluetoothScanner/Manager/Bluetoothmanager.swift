//
//  Bluetoothmanager.swift
//  BluetoothScanner
//
//  Created by Hlwan Aung Phyo on 2025/03/01.
//

import Foundation
import CoreBluetooth


typealias peripheralDiscoveredHandler = (Set<CBPeripheral>) -> Void

class Bluetoothmanager:NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    
    private var availablePeripherals: Set<CBPeripheral> = []
    private var availableServices: [CBService] = []
    private var availableCharacteristics: [CBCharacteristic] = []
    
    private var selectedPeripheral: CBPeripheral?

    var onPeripheralDiscovered: peripheralDiscoveredHandler? = nil
    var onConnectionUpdate: ((Bool) -> Void)? = nil
    var onServicesUpdate: (([CBService]) -> Void)?
    var onCharacteristicsUpdate: (([CBCharacteristic]) -> Void)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScan()
        } else {
            Logger.standard.error("Bluetoothデバイスがオンではありません")
        }
    }
    
    func startScan() {
        availablePeripherals.removeAll() // 既存のデバイスを削除する
        availableServices.removeAll()
        availableCharacteristics.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        availablePeripherals.insert(peripheral)
        onPeripheralDiscovered?(availablePeripherals)
    }
    
    func connectTo(_ peripheral: CBPeripheral) {
        centralManager.stopScan()
        selectedPeripheral = peripheral
        selectedPeripheral?.delegate = self
        guard centralManager.state == .poweredOn else {
            Logger.standard.error("デバイスがオンになっていません")
            return
        }
        centralManager.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Logger.standard.info("\(peripheral.name ?? "無名")接続成功")
        availableServices.removeAll()
        availableCharacteristics.removeAll()
        peripheral.discoverServices(nil)
        onConnectionUpdate?(true) // ViewModelに接続完了通知
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let services = peripheral.services {
            availableServices = services
            onServicesUpdate?(services)
        }
    }
    
    func discoverCharacteristics(for service: CBService) {
        selectedPeripheral?.discoverCharacteristics(nil, for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let characteristics = service.characteristics {
            availableCharacteristics = characteristics
            onCharacteristicsUpdate?(characteristics)
        }
    }
}
