//
//  PlaylistPreviewView.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 02/10/2025.
//

import SwiftUI

struct PlaylistPreviewView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: PlaylistPreviewViewModel
    let onConfirm: () -> Void
    
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(vm.passages, id: \.self.location.display) { passage in
                    VStack(spacing: 20) {
                        Text("\(passage.text)")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text("\(passage.displayLocationWithCopyright)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .onAppear {
                vm.fetchReferences()
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle(vm.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add Playlist") {
                        onConfirm()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PlaylistPreviewView(
        vm: PlaylistPreviewViewModel(title: "Example Playlist", translation: .esv, locations: VerseLocation.curatedVerses()), onConfirm: { print("Confirmed!") }
    )
}
