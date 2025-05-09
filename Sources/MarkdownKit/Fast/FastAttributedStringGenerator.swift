//
//  FastAttributedStringGenerator.swift
//  MarkdownKit
//
//  Created by Alan McCosh on 5/9/25.
//  Copyright © 2025 while software LLC.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
#elseif os(macOS)
  import Cocoa
#endif

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

///
/// `FastAttributedStringGenerator` provides functionality for converting Markdown blocks into
/// `NSAttributedString` objects that are used in macOS and iOS for displaying rich text.
/// The implementation is extensible allowing subclasses of `AttributedStringGenerator` to
/// override how individual Markdown structures are converted into attributed strings.
///
open class FastAttributedStringGenerator {
  
  /// Options for the attributed string generator
  public struct Options: OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }
    
    public static let dummyOption = Options(rawValue: 1 << 0)
  }

  /// Default `FastAttributedStringGenerator` implementation.
  public static let standard: FastAttributedStringGenerator = FastAttributedStringGenerator()
  
  /// The generator options.
  public let options: Options
  
  /// The base font size.
  public let fontSize: Float

  /// The base font family.
  public let fontFamily: String

  /// The base font color.
  public let fontColor: String
  
  
  /// Constructor providing customization options for the generated `NSAttributedString` markup.
  public init(options: Options = [],
              fontSize: Float = 14.0,
              fontFamily: String = "\"Times New Roman\",Times,serif",
              fontColor: String = mdDefaultColor) {
    self.options = options
    self.fontSize = fontSize
    self.fontFamily = fontFamily
    self.fontColor = fontColor
  }

  /// Generates an attributed string from the given Markdown document
  open func generate(block: Block, appendingTo existing: NSMutableAttributedString = NSMutableAttributedString()) -> NSMutableAttributedString {
      var updated = existing
      switch block {
      case .document(let document):
          updated = generate(blocks: document, appendingTo: updated)
      case .heading(let level, let text):
          let attributes:[NSAttributedString.Key:Any] = [
            .foregroundColor: self.fontColor,
            .strokeColor: self.fontColor,
            .font: NSFont(name: self.fontFamily, size: CGFloat(self.fontSize * 2.0))!,
            .kern: 0,
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 0
                paragraphStyle.minimumLineHeight = 1.2 * CGFloat(self.fontSize * 2.0)
                paragraphStyle.maximumLineHeight = 0
                paragraphStyle.lineSpacing = 0
                
                paragraphStyle.paragraphSpacing = CGFloat(self.fontSize)
                paragraphStyle.paragraphSpacingBefore = 0
                
                paragraphStyle.firstLineHeadIndent = 0
                paragraphStyle.headIndent = 0
                paragraphStyle.tailIndent = 0
                
                paragraphStyle.allowsDefaultTighteningForTruncation = false
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.lineBreakStrategy = .standard
                
                paragraphStyle.baseWritingDirection = .leftToRight
                paragraphStyle.hyphenationFactor = 0
                paragraphStyle.headerLevel = Int(level)
                return paragraphStyle
            }
          ]
          /*
           NSColor: kCGColorSpaceModelRGB 0 0 0 1
           NSStrokeWidth: 0
           NSParagraphStyle: Alignment Natural, LineSpacing 0, ParagraphSpacing 32, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 0, LineHeight 76.8/0, LineHeightMultiple 0, LineBreakMode WordWrapping, Tabs (
       ), DefaultTabInterval 36, Blocks (
       ), Lists (
       ), BaseWritingDirection LeftToRight, HyphenationFactor 0, TighteningForTruncation NO, HeaderLevel 1 LineBreakStrategy 0 PresentationIntents (
       ) ListIntentOrdinal 0 CodeBlockIntentLanguageHint ''
           NSFont: <UICTFont: 0x103e1b1b0> font-family: ".SFUI-Bold"; font-weight: bold; font-style: normal; font-size: 64.00pt
           NSKern: 0
           NSStrokeColor: kCGColorSpaceModelRGB 0 0 0 1
           */
          //        attributedString.addAttributes(
          //            [
          //                .paragraphStyle: NSParagraphStyle(),
          //            ],
          //            range: NSRange(location: 0, length: attributedString.length)
          //        )
          
          
          let newPart = NSAttributedString(
            string: generate(text: text),
              attributes: attributes
          )
          
          updated.append(newPart)
          
      case .paragraph(let text):
          let attributes:[NSAttributedString.Key:Any] = [
            .foregroundColor: self.fontColor,
            .strokeColor: self.fontColor,
            .font: NSFont(name: self.fontFamily, size: CGFloat(self.fontSize))!,
            .kern: 0,
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 0
                paragraphStyle.minimumLineHeight = 1.2 * CGFloat(self.fontSize)
                paragraphStyle.maximumLineHeight = 0
                paragraphStyle.lineSpacing = 0
                
                paragraphStyle.paragraphSpacing = 0.7 * CGFloat(self.fontSize)
                paragraphStyle.paragraphSpacingBefore = 0
                
                paragraphStyle.firstLineHeadIndent = 0
                paragraphStyle.headIndent = 0
                paragraphStyle.tailIndent = 0
                
                paragraphStyle.allowsDefaultTighteningForTruncation = false
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.lineBreakStrategy = .standard
                
                paragraphStyle.baseWritingDirection = .leftToRight
                paragraphStyle.hyphenationFactor = 0
                return paragraphStyle
            }
          ]
          /*
           NSColor: kCGColorSpaceModelRGB 0 0 0 1
           NSStrokeWidth: 0
           NSParagraphStyle: Alignment Natural, LineSpacing 0, ParagraphSpacing 32, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 0, LineHeight 76.8/0, LineHeightMultiple 0, LineBreakMode WordWrapping, Tabs (
       ), DefaultTabInterval 36, Blocks (
       ), Lists (
       ), BaseWritingDirection LeftToRight, HyphenationFactor 0, TighteningForTruncation NO, HeaderLevel 1 LineBreakStrategy 0 PresentationIntents (
       ) ListIntentOrdinal 0 CodeBlockIntentLanguageHint ''
           NSFont: <UICTFont: 0x103e1b1b0> font-family: ".SFUI-Bold"; font-weight: bold; font-style: normal; font-size: 64.00pt
           NSKern: 0
           NSStrokeColor: kCGColorSpaceModelRGB 0 0 0 1
           */
          //        attributedString.addAttributes(
          //            [
          //                .paragraphStyle: NSParagraphStyle(),
          //            ],
          //            range: NSRange(location: 0, length: attributedString.length)
          //        )
          
          
          let newPart = NSAttributedString(
            string: generate(text: text),
              attributes: attributes
          )
          
          updated.append(newPart)
      default:
          break
      }
      return updated
  }

//  /// Generates an attributed string from the given Markdown blocks
//  open func generate(block: Block) -> NSMutableAttributedString? {
//    return self.generateAttributedString(self.htmlGenerator.generate(block: block, parent: .none))
//  }
//
//  /// Generates an attributed string from the given Markdown blocks
  open func generate(blocks: Blocks, appendingTo existing: NSMutableAttributedString = NSMutableAttributedString()) -> NSMutableAttributedString {
      var updated = existing
      for block in blocks {
          updated = self.generate(block:block, appendingTo: updated)
      }
      return updated
  }
    
    
    open func generate(text: Text) -> String {
      var res = ""
      for fragment in text {
        res += self.generate(textFragment: fragment)
      }
      return res
    }

    open func generate(textFragment fragment: TextFragment) -> String {
      switch fragment {
        case .text(let str):
          return String(str).decodingNamedCharacters().encodingPredefinedXmlEntities()
        case .code(let str):
          return "<code>" + String(str).encodingPredefinedXmlEntities() + "</code>"
        case .emph(let text):
          return "<em>" + self.generate(text: text) + "</em>"
        case .strong(let text):
          return "<strong>" + self.generate(text: text) + "</strong>"
        case .link(let text, let uri, let title):
          let titleAttr = title == nil ? "" : " title=\"\(title!)\""
          return "<a href=\"\(uri ?? "")\"\(titleAttr)>" + self.generate(text: text) + "</a>"
        case .autolink(let type, let str):
          switch type {
            case .uri:
              return "<a href=\"\(str)\">\(str)</a>"
            case .email:
              return "<a href=\"mailto:\(str)\">\(str)</a>"
          }
        case .image(let text, let uri, let title):
          let titleAttr = title == nil ? "" : " title=\"\(title!)\""
          if let uri = uri {
            return "<img src=\"\(uri)\" alt=\"\(text.rawDescription)\"\(titleAttr)/>"
          } else {
            return self.generate(text: text)
          }
        case .html(let tag):
          return "<\(tag.description)>"
        case .delimiter(let ch, let n, _):
          let char: String
          switch ch {
            case "<":
              char = "&lt;"
            case ">":
              char = "&gt;"
            default:
              char = String(ch)
          }
          var res = char
          for _ in 1..<n {
            res.append(char)
          }
          return res
        case .softLineBreak:
          return "\n"
        case .hardLineBreak:
          return "<br/>"
        case .custom(let customTextFragment):
          return "<custom/>"
      }
    }

//  open var h1Style: String {
//    return "font-size: \(self.fontSize + 6)px;" +
//           "color: \(self.h1Color);" +
//           "margin: 0.7em 0 0.5em 0;"
//  }
//
//  open var paragraphStyle: String {
//    return "margin: 0.7em 0;"
//  }

}

#endif
