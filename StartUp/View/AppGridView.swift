import SwiftUI
import UniformTypeIdentifiers

struct AppGridView: View {
    @Binding var apps: [AppInfo]
    @Binding var page: Int
    @State private var draggingApp: AppInfo? = nil
    let columns = Array(repeating: GridItem(.flexible(), spacing: 32), count: 6)
    let iconsPerPage = 24
    
    var pagedApps: [AppInfo] {
        let start = page * iconsPerPage
        let end = min(start + iconsPerPage, apps.count)
        if start < end {
            return Array(apps[start..<end])
        } else {
            return []
        }
    }
    
    var totalPages: Int {
        (apps.count + iconsPerPage - 1) / iconsPerPage
    }
    
    func goToPreviousPage() {
        withAnimation(.easeInOut) {
            if page > 0 { page -= 1 }
        }
    }
    
    func goToNextPage() {
        withAnimation(.easeInOut) {
            if page < totalPages - 1 { page += 1 }
        }
    }
    
    func openApp(_ app: AppInfo) {
        NSWorkspace.shared.open(app.url)
    }
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(pagedApps) { app in
                        VStack {
                            Image(nsImage: app.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 128, height: 128)
                                .cornerRadius(28)
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            Text(app.name)
                                .font(.title3)
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        .frame(width: 140)
                        .scaleEffect(draggingApp?.id == app.id ? 1.1 : 1.0)
                        .opacity(draggingApp?.id == app.id ? 0.7 : 1.0)
                        .onTapGesture {
                            openApp(app)
                        }
                        .onDrag {
                            self.draggingApp = app
                            return NSItemProvider(object: app.name as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: AppDropDelegate(
                            item: app,
                            current: $draggingApp,
                            apps: $apps,
                            page: page,
                            iconsPerPage: iconsPerPage
                        ))
                    }
                }
                .padding(40)
                //.animation(.easeInOut, value: pagedApps)
            }
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width < -50 {
                        goToNextPage()
                    } else if value.translation.width > 50 {
                        goToPreviousPage()
                    }
                }
            )
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { event in
                    if abs(event.scrollingDeltaX) > abs(event.scrollingDeltaY) {
                        if event.scrollingDeltaX > 10 {
                            goToPreviousPage()
                        } else if event.scrollingDeltaX < -10 {
                            goToNextPage()
                        }
                    } else if abs(event.scrollingDeltaY) > 10 {
                        if event.scrollingDeltaY > 0 {
                            goToNextPage()
                        } else if event.scrollingDeltaY < 0 {
                            goToPreviousPage()
                        }
                    }
                    return event
                }
            }
            Spacer()
            HStack {
                Button(action: {
                    goToPreviousPage()
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(page > 0 ? .white : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(page == 0)
                Text("第 \(page+1) / \(max(totalPages,1)) 页")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.horizontal, 32)
                Button(action: {
                    goToNextPage()
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(page < totalPages - 1 ? .white : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(page >= totalPages - 1)
            }
            .padding(.bottom, 32)
        }
    }
}
