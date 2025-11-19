//
//  EditCustomDNSView.swift
//  DNS Easy Switcher
//
//  Created by Gregory LINFORD on 25/02/2025.
//

import SwiftUI

struct EditCustomDNSView: View {
    let server: CustomDNSServer
    var onComplete: (CustomDNSServer?) -> Void

    @State private var name: String
    @State private var serversLine: String

    init(server: CustomDNSServer, onComplete: @escaping (CustomDNSServer?) -> Void) {
        self.server = server
        self.onComplete = onComplete
        _name = State(initialValue: server.name)
        _serversLine = State(initialValue: server.servers.joined(separator: " "))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Name (e.g. Work DNS)", text: $name)
                .textFieldStyle(.roundedBorder)

            TextField("Space-separated DNS servers (e.g. 8.8.8.8 8.8.4.4)", text: $serversLine)
                .textFieldStyle(.roundedBorder)
                .help("Each server has an IPv4 or IPv6 address and an optional :port (e.g. 127.0.0.1:5353)")

            HStack {
                Button("Cancel") {
                    onComplete(nil)
                }
                .keyboardShortcut(.escape)

                Spacer()

                Button("Save") {
                    let parts = serversLine.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
                    guard !name.isEmpty && !parts.isEmpty else { return }
                    let updatedServer = CustomDNSServer(
                        id: server.id,
                        name: name,
                        servers: parts,
                        timestamp: server.timestamp
                    )
                    onComplete(updatedServer)
                }
                .keyboardShortcut(.return)
                .disabled(name.isEmpty || serversLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
        .frame(width: 350)
    }
}
