import Foundation

enum CatalogCategory: String, CaseIterable {
    case tokens = "Tokens"
    case contentViews = "Content Views"
    case inputViews = "Input Views"
    case layout = "Layout"
    case wrappers = "Wrappers"
    case composed = "Composed"
}

struct CatalogItem: Equatable {
    let id: String
    let name: String
    let category: CatalogCategory

    static let all: [CatalogItem] = [
        // Tokens
        CatalogItem(id: "typography", name: "Typography", category: .tokens),
        CatalogItem(id: "colors", name: "Colors", category: .tokens),
        CatalogItem(id: "spacing", name: "Spacing", category: .tokens),
        CatalogItem(id: "opacity", name: "Opacity", category: .tokens),
        CatalogItem(id: "shape-presets", name: "Shape Presets", category: .tokens),
        CatalogItem(id: "shadow-presets", name: "Shadow Presets", category: .tokens),
        // Content Views
        CatalogItem(id: "etext", name: "EText", category: .contentViews),
        CatalogItem(id: "eicon", name: "EIcon", category: .contentViews),
        CatalogItem(id: "erichlabel", name: "ERichLabel", category: .contentViews),
        CatalogItem(id: "eimage", name: "EImage", category: .contentViews),
        CatalogItem(id: "edivider", name: "EDivider", category: .contentViews),
        CatalogItem(id: "eprogressbar", name: "EProgressBar", category: .contentViews),
        CatalogItem(id: "eactivityindicator", name: "EActivityIndicator", category: .contentViews),
        CatalogItem(id: "eanimationview", name: "EAnimationView", category: .contentViews),
        // Input Views
        CatalogItem(id: "etextfield", name: "ETextField", category: .inputViews),
        CatalogItem(id: "etextview", name: "ETextView", category: .inputViews),
        CatalogItem(id: "etoggle", name: "EToggle", category: .inputViews),
        CatalogItem(id: "eslider", name: "ESlider", category: .inputViews),
        CatalogItem(id: "edropdown", name: "EDropdown", category: .inputViews),
        // Layout
        CatalogItem(id: "estack", name: "EStack", category: .layout),
        CatalogItem(id: "eoverlay", name: "EOverlay", category: .layout),
        CatalogItem(id: "escroll", name: "EScroll", category: .layout),
        CatalogItem(id: "espacer", name: "ESpacer", category: .layout),
        CatalogItem(id: "esplitview", name: "ESplitView", category: .layout),
        // Wrappers
        CatalogItem(id: "etapcontainer", name: "ETapContainer", category: .wrappers),
        CatalogItem(id: "eselectioncontainer", name: "ESelectionContainer", category: .wrappers),
        CatalogItem(id: "eanimationcontainer", name: "EAnimationContainer", category: .wrappers),
        CatalogItem(id: "elistcontainer", name: "EListContainer", category: .wrappers),
        CatalogItem(id: "enativecontainer", name: "ENativeContainer", category: .wrappers),
        CatalogItem(id: "edisclosure", name: "EDisclosure", category: .wrappers),
        // Composed
        CatalogItem(id: "einfocard", name: "EInfoCard", category: .composed),
        CatalogItem(id: "esegmentcontrol", name: "ESegmentControl", category: .composed),
    ]

    static func grouped() -> [(category: CatalogCategory, items: [CatalogItem])] {
        CatalogCategory.allCases.compactMap { cat in
            let items = all.filter { $0.category == cat }
            return items.isEmpty ? nil : (cat, items)
        }
    }
}
