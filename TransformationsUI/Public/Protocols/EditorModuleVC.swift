//
//  EditorModule.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 29/10/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import UIKit

public protocol EditorModuleVC: UIViewController {
    var imageView: CIImageView { get }
    var delegate: EditorModuleVCDelegate? { get set }

    func getTitleView() -> UIView?
    func getRenderNode() -> RenderNode

    func editorRestoredSnapshot()
}

extension EditorModuleVC {
    public func buildImageView() -> CIImageView {
        return MetalImageView()
    }

    public func updateImageView() {
        imageView.image = getRenderNode().pipeline?.outputImage
    }

    public func getTitleView() -> UIView? {
        return nil
    }

    public func editorRestoredSnapshot() {
        // NO-OP
    }
}
