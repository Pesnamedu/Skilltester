//
//  SkilltesterApp.swift
//  Skilltester
//
//  Created by Luky on 02.07.2026.
//

import SwiftUI

@main
struct SkilltesterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 700, maxWidth: 700, minHeight: 600, maxHeight: 600)
                .background(WindowAccesor())
        }
        .windowStyle(.hiddenTitleBar)
    }
}

import AppKit

struct WindowAccesor: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window{
                window.backgroundColor = .clear
                window.isOpaque = false
                window.isMovableByWindowBackground = true
                
                window.styleMask.remove(.resizable)
                
                if let contentView = window.contentView{
                    let blurView = NSVisualEffectView(frame: window.contentView?.bounds ?? .zero)
                    blurView.autoresizingMask = [.width, .height]
                    blurView.material = .hudWindow
                    blurView.blendingMode = .behindWindow
                    blurView.state = .active
                    
                    contentView.superview?.addSubview(blurView, positioned: .below, relativeTo: contentView)
                }
            }
        }
        return view
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {}
}
