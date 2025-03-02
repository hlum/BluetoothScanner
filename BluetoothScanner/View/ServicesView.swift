//
//  Services.swift
//  BluetoothScanner
//
//  Created by Hlwan Aung Phyo on 2025/03/01.
//

import SwiftUI
import CoreBluetooth

struct ServicesView: View {
    let selectedPeripheral: CBPeripheral
    @State private var vm: ServicesViewModel

    init(selectedPeripheral: CBPeripheral) {
        self.selectedPeripheral = selectedPeripheral
        vm = .init(selectedPeripheral: selectedPeripheral)
    }
    var body: some View {
        VStack {
            if vm.availableServices.isEmpty {
                ContentUnavailableView("サービスがありせん", systemImage: "exclamationmark.magnifyingglass")
            } else {
                List(vm.availableServices, id: \.self) { service in
                    NavigationLink {
                        
                    } label: {
                        VStack {
                            Text(service.description)
                            Text("id: " + service.uuid.uuidString)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("デバイスリスト")
            }
        }
        .onAppear {
            vm.listenForServices()
        }
    }
}


