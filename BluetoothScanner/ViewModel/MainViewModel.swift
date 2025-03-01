//
//  MainViewModel.swift
//  BluetoothScanner
//
//  Created by Hlwan Aung Phyo on 2025/03/01.
//

import Foundation
import CoreBluetooth

@Observable
final class MainViewModel {
    @ObservationIgnored private var btManager = Bluetoothmanager()
    
    var availablePeripheral: [CBPeripheral] = []
    var selectedPeripheral: CBPeripheral?
    
    func startScan() {
        btManager.startScan()
        listenToAvailablePeripherals()
    }
    
    func connectTo(_ peripheral: CBPeripheral) {
        btManager.connectTo(peripheral)
    }
    
    private func listenToAvailablePeripherals() {
        btManager.onPeripheralDiscovered = { [weak self] peripherals in
            self?.availablePeripheral = Array(peripherals)
        }
    }
}
