import Foundation

struct IconSizes {
    static let macSizes: [(CGFloat, String)] = [
        (16, "1x"), (16, "2x"),
        (32, "1x"), (32, "2x"),
        (128, "1x"), (128, "2x"),
        (256, "1x"), (256, "2x"),
        (512, "1x"), (512, "2x")
    ]

    static let iosSizes: [(CGFloat, String, String?)] = [
        (20, "1x", nil), (20, "2x", nil), (20, "3x", nil),
        (29, "1x", nil), (29, "2x", nil), (29, "3x", nil),
        (40, "1x", nil), (40, "2x", nil), (40, "3x", nil),
        (60, "2x", nil), (60, "3x", nil),
        (76, "1x", nil), (76, "2x", nil),
        (83.5, "2x", nil),
        (1024, "1x", nil), // App Store icon
        (40, "1x", "light"), (40, "2x", "light"), (40, "3x", "light"),
        (40, "1x", "dark"), (40, "2x", "dark"), (40, "3x", "dark"),
        (40, "1x", "white"), (40, "2x", "white"), (40, "3x", "white")
    ]
}
