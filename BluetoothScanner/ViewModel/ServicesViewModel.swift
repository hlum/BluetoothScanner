//
//  ServicesViewModel.swift
//  BluetoothScanner
//
//  Created by Hlwan Aung Phyo on 2025/03/01.
//

import Foundation
import CoreBluetooth

@Observable
final class ServicesViewModel {
    var selectedPeripheral: CBPeripheral
    var availableServices: [CBService] = []
    private var btManager = Bluetoothmanager()
    
    init(selectedPeripheral: CBPeripheral) {
        self.selectedPeripheral = selectedPeripheral
    }

    func listenForServices() {
        btManager.onServicesUpdate = { [weak self] services in
            self?.availableServices = services
        }
    }
}
