struct BluetoothDevice: Identifiable {
    let id = UUID()
    let name: String
    let macAddress: String
}