import UIKit

extension EmpGradient {

    public enum Preset {

        // MARK: - Soft (step 200)

        public static let lavenderToSky = EmpGradient(startColor: UIColor.Base.lavender200, endColor: UIColor.Base.sky200)
        public static let skyToMint = EmpGradient(startColor: UIColor.Base.sky200, endColor: UIColor.Base.mint200)
        public static let peachToRose = EmpGradient(startColor: UIColor.Base.peach200, endColor: UIColor.Base.rose200)
        public static let roseToLilac = EmpGradient(startColor: UIColor.Base.rose200, endColor: UIColor.Base.lilac200)

        // MARK: - Saturated (step 300)

        public static let lavenderToLilac = EmpGradient(startColor: UIColor.Base.lavender300, endColor: UIColor.Base.lilac300)
        public static let lemonToPeach = EmpGradient(startColor: UIColor.Base.lemon300, endColor: UIColor.Base.peach300)
        public static let lavenderToMint = EmpGradient(startColor: UIColor.Base.lavender300, endColor: UIColor.Base.mint300)
        public static let skyToLavender = EmpGradient(startColor: UIColor.Base.sky300, endColor: UIColor.Base.lavender300)
    }
}
