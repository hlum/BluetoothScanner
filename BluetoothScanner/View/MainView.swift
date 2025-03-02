//
//  ContentView.swift
//  BluetoothScanner
//
//  Created by Hlwan Aung Phyo on 2025/03/01.
//

import SwiftUI

struct MainView: View {
    @State var vm = MainViewModel()
    
    var body: some View {
        VStack {
            if vm.availablePeripheral.isEmpty {
                ContentUnavailableView("Bluetooth デバイスがありません", systemImage: "exclamationmark.magnifyingglass")
            } else {
                List(vm.availablePeripheral, id: \.self) { peripheral in
                    Button {
                        vm.selectedPeripheral = peripheral
                        vm.connectTo(peripheral)
                        
                    } label: {
                        Text(peripheral.name ?? "無名")
                    }
                }
                .listStyle(.plain)
                .navigationDestination(item: $vm.selectedPeripheral) { selectedPeripheral in
                    ServicesView(selectedPeripheral: selectedPeripheral)
                }
            }
            Button("Scan") {
                vm.startScan()
            }
            .navigationTitle("デバイスリスト")
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
