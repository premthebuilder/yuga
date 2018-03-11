import Foundation
import UIKit


/// Custom text attachment.
///
open class ImageAttachment: MediaAttachment {

    /// Attachment's Caption String
    ///
    open var caption: NSAttributedString? {
        didSet {
            styledCaptionCache = nil
        }
    }

    /// Attachment Alignment
    ///
    open var alignment: Alignment = .none {
        willSet {
            if newValue != alignment {
                glyphImage = nil
                styledCaptionCache = nil
            }
        }
    }

    /// Attachment Size
    ///
    open var size: Size = .none {
        willSet {
            if newValue != size {
                glyphImage = nil
            }
        }
    }

    /// Attachment's Caption String, with MediaAttachment's appearance attributes applied.
    ///
    private var styledCaptionCache: NSAttributedString?

    /// Returns the cached caption (with our custom attributes applied), or regenerates the Styled Caption, if needed.
    ///
    private var styledCaption: NSAttributedString? {
        if let caption = styledCaptionCache {
            return caption
        }

        styledCaptionCache = applyCaptionAppearance(to: caption)
        return styledCaptionCache
    }


    /// Creates a new attachment
    ///
    /// - Parameters:
    ///   - identifier: An unique identifier for the attachment
    ///   - url: the url that represents the image
    ///
    required public init(identifier: String, url: URL? = nil) {
        super.init(identifier: identifier, url: url)
    }


    /// Required Initializer
    ///
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if aDecoder.containsValue(forKey: EncodeKeys.alignment.rawValue) {
            let alignmentRaw = aDecoder.decodeInteger(forKey: EncodeKeys.alignment.rawValue)
            if let alignment = Alignment(rawValue:alignmentRaw) {
                self.alignment = alignment
            }
        }
        if aDecoder.containsValue(forKey: EncodeKeys.size.rawValue) {
            let sizeRaw = aDecoder.decodeInteger(forKey: EncodeKeys.size.rawValue)
            if let size = Size(rawValue:sizeRaw) {
                self.size = size
            }
        }
        if aDecoder.containsValue(forKey: EncodeKeys.size.rawValue),
            let caption = aDecoder.decodeObject(forKey: EncodeKeys.size.rawValue) as? NSAttributedString
        {
            self.caption = caption
        }

    }

    /// Required Initializer
    ///
    required public init(data contentData: Data?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
    }


    // MARK: - NSCoder Support

    override open func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(alignment.rawValue, forKey: EncodeKeys.alignment.rawValue)
        aCoder.encode(size.rawValue, forKey: EncodeKeys.size.rawValue)
        aCoder.encode(caption, forKey: EncodeKeys.caption.rawValue)
    }

    private enum EncodeKeys: String {
        case alignment
        case size
        case caption
    }


    // MARK: - OnScreen Metrics

    /// Returns the Attachment's Onscreen Height: should include any margins!
    ///
    override func onScreenHeight(for containerWidth: CGFloat) -> CGFloat {
        guard let _ = caption else {
            return super.onScreenHeight(for: containerWidth)
        }

        return appearance.imageInsets.top + imageHeight(for: containerWidth) + appearance.imageInsets.bottom +
                appearance.captionInsets.top + captionSize(for: containerWidth).height + appearance.captionInsets.bottom
    }


    // MARK: - Image Metrics

    /// Returns the x position for the image, for the specified container width.
    ///
    override func imagePositionX(for containerWidth: CGFloat) -> CGFloat {
        let imageWidth = onScreenWidth(for: containerWidth)

        switch alignment {
        case .center:
            return CGFloat(floor((containerWidth - imageWidth) / 2))
        case .right:
            return CGFloat(floor(containerWidth - imageWidth))
        default:
            return 0
        }
    }

    /// Returns the Image Width, for the specified container width.
    ///
    override func imageWidth(for containerWidth: CGFloat) -> CGFloat {
        guard let image = image else {
            return 0
        }

        switch size {
        case .full, .none:
            return floor(min(image.size.width, containerWidth))
        default:
            return floor(min(min(image.size.width,size.width), containerWidth))
        }
    }


    // MARK: - Caption Metrics

    /// Returns the Caption's Position X for the current Caption's Width, to be displayed within a specific Container's Width.
    ///
    func captionPositionX(for captionWidth: CGFloat, within containerWidth: CGFloat) -> CGFloat {
        switch alignment {
        case .center:
            return CGFloat(floor((containerWidth - captionWidth) * 0.5))
        case .right:
            return CGFloat(floor(containerWidth - captionWidth))
        default:
            return 0
        }
    }

    /// Returns the Caption Size for the specified container width. (.zero if there is no caption!).
    ///
    func captionSize(for containerWidth: CGFloat) -> CGSize {
        guard let caption = caption else {
            return .zero
        }

        let containerSize = CGSize(width: containerWidth, height: .greatestFiniteMagnitude)
        return caption.boundingRect(with: containerSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
    }

    /// Returns the Caption's Bounds for a given Container and Media Bounds Set.
    ///
    func captionBounds(containerBounds: CGRect, mediaBounds: CGRect) -> CGRect {
        let captionSize = self.captionSize(for: containerBounds.width)
        let captionX = captionPositionX(for: captionSize.width, within: containerBounds.width)
        let captionY = mediaBounds.maxY + appearance.imageInsets.bottom + appearance.captionInsets.top

        return CGRect(x: captionX, y: captionY, width: captionSize.width, height: captionSize.height).integral
    }


    // MARK: - Drawing

    /// Draws ImageAttachment specific fields, within the specified bounds.
    ///
    override func drawCustomElements(in bounds: CGRect, mediaBounds: CGRect) {
        guard let styledCaption = styledCaption else {
            return
        }
        

        let styledBounds = captionBounds(containerBounds: bounds, mediaBounds: mediaBounds)
        styledCaption.draw(in: styledBounds)
    }
}


// MARK: - Private Methods
//
private extension ImageAttachment {

    func applyCaptionAppearance(to caption: NSAttributedString?) -> NSAttributedString? {
        guard let updatedCaption = caption?.mutableCopy() as? NSMutableAttributedString else {
            return nil
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment.textAlignment()

        let captionAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: appearance.captionColor,
            .paragraphStyle: paragraphStyle
        ]

        updatedCaption.addAttributes(captionAttributes, range: updatedCaption.rangeOfEntireString)
        return updatedCaption
    }
}


// MARK: - NSCopying
//
extension ImageAttachment {

    override public func copy(with zone: NSZone? = nil) -> Any {
        guard let clone = super.copy(with: nil) as? ImageAttachment else {
            fatalError()
        }

        clone.size = size
        clone.alignment = alignment
        clone.caption = caption

        return clone
    }
}


// MARL: - Nested Types
//
extension ImageAttachment {

    /// Alignment
    ///
    public enum Alignment: Int {
        case none
        case left
        case center
        case right

        func htmlString() -> String {
            switch self {
                case .center:
                    return "aligncenter"
                case .left:
                    return "alignleft"
                case .right:
                    return "alignright"
                case .none:
                    return "alignnone"
            }
        }

        func textAlignment() -> NSTextAlignment {
            switch self {
            case .center:
                return .center
            case .left:
                return .left
            case .right:
                return .right
            case .none:
                return .natural
            }
        }

        static let mappedValues:[String: Alignment] = [
            Alignment.none.htmlString():.none,
            Alignment.left.htmlString():.left,
            Alignment.center.htmlString():.center,
            Alignment.right.htmlString():.right
        ]

        static func fromHTML(string value: String) -> Alignment? {
            return mappedValues[value]
        }
    }

    /// Size Onscreen!
    ///
    public enum Size: Int {
        case thumbnail
        case medium
        case large
        case full
        case none

        var shouldResizeAsset: Bool {
            return width != Settings.maximum
        }

        func htmlString() -> String {
            switch self {
            case .thumbnail:
                return "size-thumbnail"
            case .medium:
                return "size-medium"
            case .large:
                return "size-large"
            case .full:
                return "size-full"
            case .none:
                return ""
            }
        }

        static let mappedValues: [String: Size] = [
            Size.thumbnail.htmlString():.thumbnail,
            Size.medium.htmlString():.medium,
            Size.large.htmlString():.large,
            Size.full.htmlString():.full,
            Size.none.htmlString():.none
        ]

        static func fromHTML(string value: String) -> Size? {
            return mappedValues[value]
        }

        var width: CGFloat {
            switch self {
            case .thumbnail: return Settings.thumbnail
            case .medium: return Settings.medium
            case .large: return Settings.large
            case .full: return Settings.maximum
            case .none: return Settings.maximum
            }
        }

        fileprivate struct Settings {
            static let thumbnail = CGFloat(135)
            static let medium = CGFloat(270)
            static let large = CGFloat(360)
            static let maximum = CGFloat.greatestFiniteMagnitude
        }
    }
}
