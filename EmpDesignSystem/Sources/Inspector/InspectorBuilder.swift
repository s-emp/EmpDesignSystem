import Cocoa
import EmpUI_macOS

@MainActor
final class InspectorBuilder {

    var onViewModelChanged: ((Any) -> Void)?

    // MARK: - Build

    func build(for item: CatalogItem, viewModel: Any) -> NSView {
        let scroll = EScroll()
        let _ = scroll.configure(with: .init(
            common: .init(backgroundColor: .Semantic.backgroundSecondary),
            orientation: .vertical
        ))

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)),
            orientation: .vertical,
            spacing: 12,
            alignment: .leading,
            distribution: .fill
        ))

        let header = EText()
        let _ = header.configure(with: .init(
            content: .plain(.init(
                text: "Inspector",
                font: .systemFont(ofSize: 14, weight: .bold),
                color: .Semantic.textPrimary
            ))
        ))
        stack.addArrangedSubview(header)

        let divider = EDivider()
        let _ = divider.configure(with: .init())
        stack.addArrangedSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])

        let rows = makeRows(for: item.id, viewModel: viewModel)
        for row in rows {
            stack.addArrangedSubview(row)
            row.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                row.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            ])
        }

        // Embed stack into scroll as documentView
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = stack

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scroll.contentView.trailingAnchor),
        ])

        return scroll
    }

    // MARK: - Router

    private func makeRows(for itemId: String, viewModel: Any) -> [NSView] {
        switch itemId {
        case "etext":
            return makeETextRows(viewModel)
        case "eicon":
            return makeEIconRows(viewModel)
        case "edivider":
            return makeEDividerRows(viewModel)
        case "eprogressbar":
            return makeEProgressBarRows(viewModel)
        case "etoggle":
            return makeEToggleRows(viewModel)
        case "eslider":
            return makeESliderRows(viewModel)
        case "edropdown":
            return makeEDropdownRows(viewModel)
        case "etextfield":
            return makeETextFieldRows(viewModel)
        case "eactivityindicator":
            return makeEActivityIndicatorRows(viewModel)
        default:
            return [makeComingSoon()]
        }
    }

    // MARK: - Coming Soon

    private func makeComingSoon() -> NSView {
        let label = EText()
        let _ = label.configure(with: .init(
            content: .plain(.init(
                text: "Inspector coming soon",
                font: .systemFont(ofSize: 12),
                color: .Semantic.textTertiary
            )),
            alignment: .center
        ))
        return label
    }

    // MARK: - Common Section

    private func makeCommonSection(
        _ common: CommonViewModel,
        onChange: @escaping (CommonViewModel) -> Void
    ) -> NSView {
        let disclosure = EDisclosure()
        let _ = disclosure.configure(with: .init(title: "CommonViewModel", isExpanded: false))

        var current = common

        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .vertical,
            spacing: 8,
            alignment: .leading
        ))

        // Background color
        let bgRow = PropertyRow.colorDropdown(
            label: "backgroundColor",
            selectedName: PropertyRow.nameForColor(current.backgroundColor)
        ) { name in
            current = CommonViewModel(
                border: current.border,
                shadow: current.shadow,
                corners: current.corners,
                backgroundColor: PropertyRow.colorForName(name),
                layoutMargins: current.layoutMargins,
                size: current.size
            )
            onChange(current)
        }
        stack.addArrangedSubview(bgRow)
        pinWidth(bgRow, to: stack)

        // Border disclosure
        let borderDisclosure = makeBorderSection(current.border) { newBorder in
            current = CommonViewModel(
                border: newBorder,
                shadow: current.shadow,
                corners: current.corners,
                backgroundColor: current.backgroundColor,
                layoutMargins: current.layoutMargins,
                size: current.size
            )
            onChange(current)
        }
        stack.addArrangedSubview(borderDisclosure)
        pinWidth(borderDisclosure, to: stack)

        // Corners disclosure
        let cornersDisclosure = makeCornersSection(current.corners) { newCorners in
            current = CommonViewModel(
                border: current.border,
                shadow: current.shadow,
                corners: newCorners,
                backgroundColor: current.backgroundColor,
                layoutMargins: current.layoutMargins,
                size: current.size
            )
            onChange(current)
        }
        stack.addArrangedSubview(cornersDisclosure)
        pinWidth(cornersDisclosure, to: stack)

        // Shadow disclosure
        let shadowDisclosure = makeShadowSection(current.shadow) { newShadow in
            current = CommonViewModel(
                border: current.border,
                shadow: newShadow,
                corners: current.corners,
                backgroundColor: current.backgroundColor,
                layoutMargins: current.layoutMargins,
                size: current.size
            )
            onChange(current)
        }
        stack.addArrangedSubview(shadowDisclosure)
        pinWidth(shadowDisclosure, to: stack)

        // Layout margins disclosure
        let marginsDisclosure = makeMarginsSection(current.layoutMargins) { newMargins in
            current = CommonViewModel(
                border: current.border,
                shadow: current.shadow,
                corners: current.corners,
                backgroundColor: current.backgroundColor,
                layoutMargins: newMargins,
                size: current.size
            )
            onChange(current)
        }
        stack.addArrangedSubview(marginsDisclosure)
        pinWidth(marginsDisclosure, to: stack)

        disclosure.setContent(stack)
        disclosure.onToggle = { isExpanded in
            let _ = disclosure.configure(with: .init(
                title: "CommonViewModel",
                isExpanded: isExpanded
            ))
        }

        return disclosure
    }

    // MARK: - Border Section

    private func makeBorderSection(
        _ border: CommonViewModel.Border,
        onChange: @escaping (CommonViewModel.Border) -> Void
    ) -> NSView {
        let disclosure = EDisclosure()
        let _ = disclosure.configure(with: .init(title: "Border", isExpanded: false))

        var current = border

        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .vertical,
            spacing: 6,
            alignment: .leading
        ))

        let widthRow = PropertyRow.slider(
            label: "width",
            value: Double(current.width),
            min: 0,
            max: 10,
            step: 0.5
        ) { val in
            current = CommonViewModel.Border(
                width: CGFloat(val),
                color: current.color,
                style: current.style
            )
            onChange(current)
        }
        stack.addArrangedSubview(widthRow)
        pinWidth(widthRow, to: stack)

        let colorRow = PropertyRow.colorDropdown(
            label: "color",
            selectedName: PropertyRow.nameForColor(current.color)
        ) { name in
            current = CommonViewModel.Border(
                width: current.width,
                color: PropertyRow.colorForName(name),
                style: current.style
            )
            onChange(current)
        }
        stack.addArrangedSubview(colorRow)
        pinWidth(colorRow, to: stack)

        let styles: [String] = ["solid", "dashed"]
        let styleIndex = current.style == .solid ? 0 : 1
        let styleRow = PropertyRow.dropdown(
            label: "style",
            options: styles,
            selectedIndex: styleIndex
        ) { idx in
            let style: CommonViewModel.Border.Style = idx == 0 ? .solid : .dashed
            current = CommonViewModel.Border(
                width: current.width,
                color: current.color,
                style: style
            )
            onChange(current)
        }
        stack.addArrangedSubview(styleRow)
        pinWidth(styleRow, to: stack)

        disclosure.setContent(stack)
        disclosure.onToggle = { isExpanded in
            let _ = disclosure.configure(with: .init(title: "Border", isExpanded: isExpanded))
        }

        return disclosure
    }

    // MARK: - Corners Section

    private func makeCornersSection(
        _ corners: CommonViewModel.Corners,
        onChange: @escaping (CommonViewModel.Corners) -> Void
    ) -> NSView {
        let disclosure = EDisclosure()
        let _ = disclosure.configure(with: .init(title: "Corners", isExpanded: false))

        var current = corners

        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .vertical,
            spacing: 6,
            alignment: .leading
        ))

        let radiusRow = PropertyRow.slider(
            label: "radius",
            value: Double(current.radius),
            min: 0,
            max: 32,
            step: 1
        ) { val in
            current = CommonViewModel.Corners(
                radius: CGFloat(val),
                maskedCorners: current.maskedCorners
            )
            onChange(current)
        }
        stack.addArrangedSubview(radiusRow)
        pinWidth(radiusRow, to: stack)

        disclosure.setContent(stack)
        disclosure.onToggle = { isExpanded in
            let _ = disclosure.configure(with: .init(title: "Corners", isExpanded: isExpanded))
        }

        return disclosure
    }

    // MARK: - Shadow Section

    private func makeShadowSection(
        _ shadow: CommonViewModel.Shadow,
        onChange: @escaping (CommonViewModel.Shadow) -> Void
    ) -> NSView {
        let disclosure = EDisclosure()
        let _ = disclosure.configure(with: .init(title: "Shadow", isExpanded: false))

        var current = shadow

        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .vertical,
            spacing: 6,
            alignment: .leading
        ))

        let radiusRow = PropertyRow.slider(
            label: "radius",
            value: Double(current.radius),
            min: 0,
            max: 20,
            step: 1
        ) { val in
            current = CommonViewModel.Shadow(
                color: current.color,
                offset: current.offset,
                radius: CGFloat(val),
                opacity: current.opacity
            )
            onChange(current)
        }
        stack.addArrangedSubview(radiusRow)
        pinWidth(radiusRow, to: stack)

        let opacityRow = PropertyRow.slider(
            label: "opacity",
            value: Double(current.opacity),
            min: 0,
            max: 1,
            step: 0.05
        ) { val in
            current = CommonViewModel.Shadow(
                color: current.color,
                offset: current.offset,
                radius: current.radius,
                opacity: Float(val)
            )
            onChange(current)
        }
        stack.addArrangedSubview(opacityRow)
        pinWidth(opacityRow, to: stack)

        let colorRow = PropertyRow.colorDropdown(
            label: "color",
            selectedName: PropertyRow.nameForColor(current.color)
        ) { name in
            current = CommonViewModel.Shadow(
                color: PropertyRow.colorForName(name),
                offset: current.offset,
                radius: current.radius,
                opacity: current.opacity
            )
            onChange(current)
        }
        stack.addArrangedSubview(colorRow)
        pinWidth(colorRow, to: stack)

        disclosure.setContent(stack)
        disclosure.onToggle = { isExpanded in
            let _ = disclosure.configure(with: .init(title: "Shadow", isExpanded: isExpanded))
        }

        return disclosure
    }

    // MARK: - Margins Section

    private func makeMarginsSection(
        _ margins: NSEdgeInsets,
        onChange: @escaping (NSEdgeInsets) -> Void
    ) -> NSView {
        let disclosure = EDisclosure()
        let _ = disclosure.configure(with: .init(title: "Layout Margins", isExpanded: false))

        var current = margins

        let stack = EStack()
        let _ = stack.configure(with: .init(
            orientation: .vertical,
            spacing: 6,
            alignment: .leading
        ))

        let topRow = PropertyRow.slider(label: "top", value: Double(current.top), min: 0, max: 32, step: 1) { val in
            current = NSEdgeInsets(top: CGFloat(val), left: current.left, bottom: current.bottom, right: current.right)
            onChange(current)
        }
        stack.addArrangedSubview(topRow)
        pinWidth(topRow, to: stack)

        let leftRow = PropertyRow.slider(label: "left", value: Double(current.left), min: 0, max: 32, step: 1) { val in
            current = NSEdgeInsets(top: current.top, left: CGFloat(val), bottom: current.bottom, right: current.right)
            onChange(current)
        }
        stack.addArrangedSubview(leftRow)
        pinWidth(leftRow, to: stack)

        let bottomRow = PropertyRow.slider(label: "bottom", value: Double(current.bottom), min: 0, max: 32, step: 1) { val in
            current = NSEdgeInsets(top: current.top, left: current.left, bottom: CGFloat(val), right: current.right)
            onChange(current)
        }
        stack.addArrangedSubview(bottomRow)
        pinWidth(bottomRow, to: stack)

        let rightRow = PropertyRow.slider(label: "right", value: Double(current.right), min: 0, max: 32, step: 1) { val in
            current = NSEdgeInsets(top: current.top, left: current.left, bottom: current.bottom, right: CGFloat(val))
            onChange(current)
        }
        stack.addArrangedSubview(rightRow)
        pinWidth(rightRow, to: stack)

        disclosure.setContent(stack)
        disclosure.onToggle = { isExpanded in
            let _ = disclosure.configure(with: .init(title: "Layout Margins", isExpanded: isExpanded))
        }

        return disclosure
    }

    // MARK: - EText

    private func makeETextRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? EText.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        // Extract current plain text values
        var text = ""
        var fontSize: CGFloat = 14
        var fontWeight: NSFont.Weight = .regular
        var textColorName = "textPrimary"

        if case let .plain(plain) = current.content {
            text = plain.text
            fontSize = plain.font.pointSize
            textColorName = PropertyRow.nameForColor(plain.color)
            // Approximate weight detection
            let traits = NSFontManager.shared.traits(of: plain.font)
            fontWeight = traits.contains(.boldFontMask) ? .bold : .regular
        }

        let textRow = PropertyRow.textField(label: "text", value: text) { [weak self] newText in
            text = newText
            let content = EText.Content.plain(.init(
                text: newText,
                font: .systemFont(ofSize: fontSize, weight: fontWeight),
                color: PropertyRow.colorForName(textColorName)
            ))
            current = EText.ViewModel(
                common: current.common,
                content: content,
                numberOfLines: current.numberOfLines,
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(textRow)

        let fontSizeRow = PropertyRow.slider(
            label: "fontSize",
            value: Double(fontSize),
            min: 8,
            max: 72,
            step: 1
        ) { [weak self] val in
            fontSize = CGFloat(val)
            let content = EText.Content.plain(.init(
                text: text,
                font: .systemFont(ofSize: fontSize, weight: fontWeight),
                color: PropertyRow.colorForName(textColorName)
            ))
            current = EText.ViewModel(
                common: current.common,
                content: content,
                numberOfLines: current.numberOfLines,
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(fontSizeRow)

        let weights = ["ultraLight", "thin", "light", "regular", "medium", "semibold", "bold", "heavy", "black"]
        let weightValues: [NSFont.Weight] = [.ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
        let weightIndex = weightValues.firstIndex(of: fontWeight) ?? 3

        let weightRow = PropertyRow.dropdown(
            label: "fontWeight",
            options: weights,
            selectedIndex: weightIndex
        ) { [weak self] idx in
            fontWeight = weightValues[idx]
            let content = EText.Content.plain(.init(
                text: text,
                font: .systemFont(ofSize: fontSize, weight: fontWeight),
                color: PropertyRow.colorForName(textColorName)
            ))
            current = EText.ViewModel(
                common: current.common,
                content: content,
                numberOfLines: current.numberOfLines,
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(weightRow)

        let colorRow = PropertyRow.colorDropdown(
            label: "color",
            selectedName: textColorName
        ) { [weak self] name in
            textColorName = name
            let content = EText.Content.plain(.init(
                text: text,
                font: .systemFont(ofSize: fontSize, weight: fontWeight),
                color: PropertyRow.colorForName(name)
            ))
            current = EText.ViewModel(
                common: current.common,
                content: content,
                numberOfLines: current.numberOfLines,
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(colorRow)

        let linesRow = PropertyRow.slider(
            label: "numberOfLines",
            value: Double(current.numberOfLines),
            min: 0,
            max: 10,
            step: 1
        ) { [weak self] val in
            current = EText.ViewModel(
                common: current.common,
                content: current.content,
                numberOfLines: Int(val),
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(linesRow)

        let alignments = ["natural", "left", "center", "right"]
        let alignValues: [NSTextAlignment] = [.natural, .left, .center, .right]
        let alignIndex = alignValues.firstIndex(of: current.alignment) ?? 0

        let alignRow = PropertyRow.dropdown(
            label: "alignment",
            options: alignments,
            selectedIndex: alignIndex
        ) { [weak self] idx in
            current = EText.ViewModel(
                common: current.common,
                content: current.content,
                numberOfLines: current.numberOfLines,
                alignment: alignValues[idx]
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(alignRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = EText.ViewModel(
                common: newCommon,
                content: current.content,
                numberOfLines: current.numberOfLines,
                alignment: current.alignment
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - EIcon

    private func makeEIconRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? EIcon.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        var symbolName = ""
        if case let .sfSymbol(name) = current.source {
            symbolName = name
        }

        let symbolRow = PropertyRow.textField(label: "sfSymbol", value: symbolName) { [weak self] newName in
            symbolName = newName
            current = EIcon.ViewModel(
                common: current.common,
                source: .sfSymbol(newName),
                size: current.size,
                tintColor: current.tintColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(symbolRow)

        let sizeRow = PropertyRow.slider(
            label: "size",
            value: Double(current.size),
            min: 8,
            max: 128,
            step: 2
        ) { [weak self] val in
            current = EIcon.ViewModel(
                common: current.common,
                source: current.source,
                size: CGFloat(val),
                tintColor: current.tintColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(sizeRow)

        let tintRow = PropertyRow.colorDropdown(
            label: "tintColor",
            selectedName: PropertyRow.nameForColor(current.tintColor)
        ) { [weak self] name in
            current = EIcon.ViewModel(
                common: current.common,
                source: current.source,
                size: current.size,
                tintColor: PropertyRow.colorForName(name)
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(tintRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = EIcon.ViewModel(
                common: newCommon,
                source: current.source,
                size: current.size,
                tintColor: current.tintColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - EDivider

    private func makeEDividerRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? EDivider.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        let axes = ["horizontal", "vertical"]
        let axisIndex = current.axis == .horizontal ? 0 : 1

        let axisRow = PropertyRow.dropdown(
            label: "axis",
            options: axes,
            selectedIndex: axisIndex
        ) { [weak self] idx in
            current = EDivider.ViewModel(
                common: current.common,
                axis: idx == 0 ? .horizontal : .vertical,
                thickness: current.thickness,
                color: current.color
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(axisRow)

        let thicknessRow = PropertyRow.slider(
            label: "thickness",
            value: Double(current.thickness),
            min: 0.5,
            max: 10,
            step: 0.5
        ) { [weak self] val in
            current = EDivider.ViewModel(
                common: current.common,
                axis: current.axis,
                thickness: CGFloat(val),
                color: current.color
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(thicknessRow)

        let colorRow = PropertyRow.colorDropdown(
            label: "color",
            selectedName: PropertyRow.nameForColor(current.color)
        ) { [weak self] name in
            current = EDivider.ViewModel(
                common: current.common,
                axis: current.axis,
                thickness: current.thickness,
                color: PropertyRow.colorForName(name)
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(colorRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = EDivider.ViewModel(
                common: newCommon,
                axis: current.axis,
                thickness: current.thickness,
                color: current.color
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - EProgressBar

    private func makeEProgressBarRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? EProgressBar.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        let progressRow = PropertyRow.slider(
            label: "progress",
            value: Double(current.progress),
            min: 0,
            max: 1,
            step: 0.01
        ) { [weak self] val in
            current = EProgressBar.ViewModel(
                common: current.common,
                progress: CGFloat(val),
                trackColor: current.trackColor,
                fillColor: current.fillColor,
                barHeight: current.barHeight
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(progressRow)

        let heightRow = PropertyRow.slider(
            label: "barHeight",
            value: Double(current.barHeight),
            min: 1,
            max: 20,
            step: 1
        ) { [weak self] val in
            current = EProgressBar.ViewModel(
                common: current.common,
                progress: current.progress,
                trackColor: current.trackColor,
                fillColor: current.fillColor,
                barHeight: CGFloat(val)
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(heightRow)

        let fillColorRow = PropertyRow.colorDropdown(
            label: "fillColor",
            selectedName: PropertyRow.nameForColor(current.fillColor)
        ) { [weak self] name in
            current = EProgressBar.ViewModel(
                common: current.common,
                progress: current.progress,
                trackColor: current.trackColor,
                fillColor: PropertyRow.colorForName(name),
                barHeight: current.barHeight
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(fillColorRow)

        let trackColorRow = PropertyRow.colorDropdown(
            label: "trackColor",
            selectedName: PropertyRow.nameForColor(current.trackColor)
        ) { [weak self] name in
            current = EProgressBar.ViewModel(
                common: current.common,
                progress: current.progress,
                trackColor: PropertyRow.colorForName(name),
                fillColor: current.fillColor,
                barHeight: current.barHeight
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(trackColorRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = EProgressBar.ViewModel(
                common: newCommon,
                progress: current.progress,
                trackColor: current.trackColor,
                fillColor: current.fillColor,
                barHeight: current.barHeight
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - EToggle

    private func makeEToggleRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? EToggle.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        let isOnRow = PropertyRow.toggle(label: "isOn", value: current.isOn) { [weak self] val in
            current = EToggle.ViewModel(
                common: current.common,
                isOn: val,
                isEnabled: current.isEnabled,
                onTintColor: current.onTintColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(isOnRow)

        let enabledRow = PropertyRow.toggle(label: "isEnabled", value: current.isEnabled) { [weak self] val in
            current = EToggle.ViewModel(
                common: current.common,
                isOn: current.isOn,
                isEnabled: val,
                onTintColor: current.onTintColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(enabledRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = EToggle.ViewModel(
                common: newCommon,
                isOn: current.isOn,
                isEnabled: current.isEnabled,
                onTintColor: current.onTintColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - ESlider

    private func makeESliderRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? ESlider.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        let valueRow = PropertyRow.slider(
            label: "value",
            value: current.value,
            min: current.minimumValue,
            max: current.maximumValue,
            step: current.step
        ) { [weak self] val in
            current = ESlider.ViewModel(
                common: current.common,
                value: val,
                minimumValue: current.minimumValue,
                maximumValue: current.maximumValue,
                step: current.step,
                isEnabled: current.isEnabled,
                trackColor: current.trackColor,
                knobColor: current.knobColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(valueRow)

        let minRow = PropertyRow.slider(
            label: "minimumValue",
            value: current.minimumValue,
            min: -100,
            max: 100,
            step: 1
        ) { [weak self] val in
            current = ESlider.ViewModel(
                common: current.common,
                value: current.value,
                minimumValue: val,
                maximumValue: current.maximumValue,
                step: current.step,
                isEnabled: current.isEnabled,
                trackColor: current.trackColor,
                knobColor: current.knobColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(minRow)

        let maxRow = PropertyRow.slider(
            label: "maximumValue",
            value: current.maximumValue,
            min: -100,
            max: 100,
            step: 1
        ) { [weak self] val in
            current = ESlider.ViewModel(
                common: current.common,
                value: current.value,
                minimumValue: current.minimumValue,
                maximumValue: val,
                step: current.step,
                isEnabled: current.isEnabled,
                trackColor: current.trackColor,
                knobColor: current.knobColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(maxRow)

        let enabledRow = PropertyRow.toggle(label: "isEnabled", value: current.isEnabled) { [weak self] val in
            current = ESlider.ViewModel(
                common: current.common,
                value: current.value,
                minimumValue: current.minimumValue,
                maximumValue: current.maximumValue,
                step: current.step,
                isEnabled: val,
                trackColor: current.trackColor,
                knobColor: current.knobColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(enabledRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = ESlider.ViewModel(
                common: newCommon,
                value: current.value,
                minimumValue: current.minimumValue,
                maximumValue: current.maximumValue,
                step: current.step,
                isEnabled: current.isEnabled,
                trackColor: current.trackColor,
                knobColor: current.knobColor
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - EDropdown

    private func makeEDropdownRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? EDropdown.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        let placeholderRow = PropertyRow.textField(
            label: "placeholder",
            value: current.placeholder
        ) { [weak self] val in
            current = EDropdown.ViewModel(
                common: current.common,
                items: current.items,
                selectedIndex: current.selectedIndex,
                placeholder: val,
                isEnabled: current.isEnabled
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(placeholderRow)

        let selectedRow = PropertyRow.slider(
            label: "selectedIndex",
            value: Double(current.selectedIndex),
            min: -1,
            max: Double(max(current.items.count - 1, 0)),
            step: 1
        ) { [weak self] val in
            current = EDropdown.ViewModel(
                common: current.common,
                items: current.items,
                selectedIndex: Int(val),
                placeholder: current.placeholder,
                isEnabled: current.isEnabled
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(selectedRow)

        let enabledRow = PropertyRow.toggle(label: "isEnabled", value: current.isEnabled) { [weak self] val in
            current = EDropdown.ViewModel(
                common: current.common,
                items: current.items,
                selectedIndex: current.selectedIndex,
                placeholder: current.placeholder,
                isEnabled: val
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(enabledRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = EDropdown.ViewModel(
                common: newCommon,
                items: current.items,
                selectedIndex: current.selectedIndex,
                placeholder: current.placeholder,
                isEnabled: current.isEnabled
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - ETextField

    private func makeETextFieldRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? ETextField.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        let textRow = PropertyRow.textField(label: "text", value: current.text) { [weak self] val in
            current = ETextField.ViewModel(
                common: current.common,
                text: val,
                placeholder: current.placeholder,
                isEnabled: current.isEnabled,
                isSecure: current.isSecure
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(textRow)

        let placeholderRow = PropertyRow.textField(
            label: "placeholder",
            value: current.placeholder
        ) { [weak self] val in
            current = ETextField.ViewModel(
                common: current.common,
                text: current.text,
                placeholder: val,
                isEnabled: current.isEnabled,
                isSecure: current.isSecure
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(placeholderRow)

        let enabledRow = PropertyRow.toggle(label: "isEnabled", value: current.isEnabled) { [weak self] val in
            current = ETextField.ViewModel(
                common: current.common,
                text: current.text,
                placeholder: current.placeholder,
                isEnabled: val,
                isSecure: current.isSecure
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(enabledRow)

        let secureRow = PropertyRow.toggle(label: "isSecure", value: current.isSecure) { [weak self] val in
            current = ETextField.ViewModel(
                common: current.common,
                text: current.text,
                placeholder: current.placeholder,
                isEnabled: current.isEnabled,
                isSecure: val
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(secureRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = ETextField.ViewModel(
                common: newCommon,
                text: current.text,
                placeholder: current.placeholder,
                isEnabled: current.isEnabled,
                isSecure: current.isSecure
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - EActivityIndicator

    private func makeEActivityIndicatorRows(_ viewModel: Any) -> [NSView] {
        guard var current = viewModel as? EActivityIndicator.ViewModel else { return [makeComingSoon()] }
        var rows: [NSView] = []

        let styles = ["small", "medium", "large"]
        let styleValues: [EActivityIndicator.ViewModel.Style] = [.small, .medium, .large]
        let styleIndex = styleValues.firstIndex(of: current.style) ?? 1

        let styleRow = PropertyRow.dropdown(
            label: "style",
            options: styles,
            selectedIndex: styleIndex
        ) { [weak self] idx in
            current = EActivityIndicator.ViewModel(
                common: current.common,
                style: styleValues[idx],
                color: current.color,
                isAnimating: current.isAnimating
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(styleRow)

        let animatingRow = PropertyRow.toggle(
            label: "isAnimating",
            value: current.isAnimating
        ) { [weak self] val in
            current = EActivityIndicator.ViewModel(
                common: current.common,
                style: current.style,
                color: current.color,
                isAnimating: val
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(animatingRow)

        let colorRow = PropertyRow.colorDropdown(
            label: "color",
            selectedName: PropertyRow.nameForColor(current.color)
        ) { [weak self] name in
            current = EActivityIndicator.ViewModel(
                common: current.common,
                style: current.style,
                color: PropertyRow.colorForName(name),
                isAnimating: current.isAnimating
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(colorRow)

        let commonSection = makeCommonSection(current.common) { [weak self] newCommon in
            current = EActivityIndicator.ViewModel(
                common: newCommon,
                style: current.style,
                color: current.color,
                isAnimating: current.isAnimating
            )
            self?.onViewModelChanged?(current)
        }
        rows.append(commonSection)

        return rows
    }

    // MARK: - Layout Helpers

    private func pinWidth(_ child: NSView, to parent: NSView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
        ])
    }
}
