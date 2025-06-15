import SwiftUI
import UniformTypeIdentifiers

struct AppDropDelegate: DropDelegate {
    let item: AppInfo
    @Binding var current: AppInfo?
    @Binding var apps: [AppInfo]
    let page: Int
    let iconsPerPage: Int
    
    func dropEntered(info: DropInfo) {
        guard let current = current, current.id != item.id,
              let fromIndex = apps.firstIndex(where: { $0.id == current.id }),
              let toIndex = apps.firstIndex(where: { $0.id == item.id }) else { return }
        if fromIndex != toIndex {
            withAnimation {
                apps.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}
