# EmpButton Snapshot Tests Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Добавить snapshot-тесты для EmpButton на обеих платформах (iOS + macOS), покрывающие все пресеты и контент-варианты.

**Architecture:** По одному тестовому файлу на платформу. Параметризованные тесты через `@Test(arguments:)` для комбинаций стиль × цвет × размер. Отдельные тесты для контент-вариантов и disabled. swift-snapshot-testing `.image` strategy.

**Tech Stack:** Swift Testing, swift-snapshot-testing, UIKit (iOS), AppKit (macOS)

---

### Task 1: Создать macOS snapshot-тесты

**Files:**
- Create: `EmpUI_macOS/Tests/EmpButtonSnapshotTests.swift`

### Task 2: Создать iOS snapshot-тесты

**Files:**
- Create: `EmpUI_iOS/Tests/EmpButtonSnapshotTests.swift`

### Task 3: Сгенерировать reference-изображения и проверить

**Steps:**
1. `mise exec -- tuist generate --no-open`
2. `mise exec -- tuist test EmpUI_macOS` — первый запуск создаст reference, тесты упадут
3. `mise exec -- tuist test EmpUI_macOS` — второй запуск — тесты пройдут
4. `mise exec -- tuist test EmpUI_iOS` — аналогично
5. `swiftformat . && swiftlint`
