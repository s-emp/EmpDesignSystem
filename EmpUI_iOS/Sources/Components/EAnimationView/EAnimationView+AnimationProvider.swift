import UIKit

/// Протокол для интеграции анимационных библиотек (Lottie и др.).
/// Потребитель реализует этот протокол, предоставляя конкретную view и методы управления.
public protocol AnimationProvider {
    /// Создаёт UIView, отображающую анимацию
    func makeView() -> UIView
    /// Запускает воспроизведение анимации
    func play(loopMode: EAnimationView.ViewModel.LoopMode)
    /// Останавливает анимацию
    func stop()
    /// Устанавливает прогресс анимации (0.0–1.0)
    func setProgress(_ progress: CGFloat)
}
