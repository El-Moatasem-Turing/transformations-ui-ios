//
//  StandardModules+Transform.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 15/11/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import TransformationsUIShared
import UIKit

public protocol ExtraModuleCommand: EditorModuleCommand {}
public protocol CropModuleCommand: EditorModuleCommand {}

extension StandardModules {
    /// Transform module configuration object.
    public class Transform: NSObject, EditorModule {
        /// :nodoc:
        public var title: String = "Transform"
        /// :nodoc:
        public var icon: UIImage? = .fromBundle("icon-module-transform")
        /// :nodoc:
        public var isEnabled: Bool = true
        /// :nodoc:
        private(set) public lazy var viewController: EditorModuleVC = { TransformViewController(module: self) }()

        /// Extra Commands available in `Transform` module.
        public var extraCommands: [ExtraModuleCommand] = [
            Commands.Rotate(),
        ]

        /// Crop Commands available in `Transform` module.
        public var cropCommands: [CropModuleCommand] = [
            Commands.Crop(type: .none),
            Commands.Crop(type: .rect),
            Commands.Crop(type: .circle)
        ]
    }
}

// MARK: - Commands

extension StandardModules.Transform {
    /// All available commands.
    public class Commands: NSObject {
        /// Rotate command.
        public class Rotate: NSObject, ExtraModuleCommand {
            /// :nodoc:
            public var title: String = "Rotate"
            /// :nodoc:
            public lazy var icon: UIImage? = UIImage.fromBundle("icon-rotate")
        }

        /// Crop command.
        public class Crop: NSObject, CropModuleCommand {
            /// :nodoc:
            public lazy var title: String = {
                switch type {
                case .none:
                    return "None"
                case .rect:
                    return "Rect"
                case .circle:
                    return "Circle"
                }
            }()

            /// :nodoc:
            public lazy var icon: UIImage? = {
                switch type {
                case .none:
                    return nil
                case .rect:
                    return .fromBundle("icon-crop")
                case .circle:
                    return .fromBundle("icon-circle")
                }
            }()

            /// Crop type.
            public enum CropType {
                case none
                case rect
                case circle
            }

            /// Determines the `CropType` to use.
            let type: CropType

            /// Designated initializer for `Crop` command.
            ///
            /// - Parameters:
            ///   - type: A `CropType`. Defaults to `rect`
            ///   - title: A title representing this crop type. Overrides the default title *(optional)*.
            ///   - icon: An icon representing this crop type. Overrides the default icon *(optional)*.
            public init(type: CropType = .rect, title: String? = nil, icon: UIImage? = nil) {
                self.type = type

                super.init()

                if let title = title {
                    self.title = title
                }

                if let icon = icon {
                    self.icon = icon
                }
            }
        }
    }
}
