import Foundation
import AppKit

struct AppInfo: Identifiable {
    let id = UUID()
    let name: String
    let icon: NSImage
    let url: URL
}

class AppListProvider {
    static func fetchApplications(in directory: URL = URL(fileURLWithPath: "/Applications")) -> [AppInfo] {
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil) else {
            return []
        }
        var apps: [AppInfo] = []
        for case let fileURL as URL in enumerator {
            if fileURL.pathExtension == "app" {
                let name = fileURL.deletingPathExtension().lastPathComponent
                let icon = NSWorkspace.shared.icon(forFile: fileURL.path)
                icon.size = NSSize(width: 96, height: 96)
                let appInfo = AppInfo(name: name, icon: icon, url: fileURL)
                apps.append(appInfo)
                enumerator.skipDescendants() // 不递归进入.app包
            }
        }
        return apps.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
