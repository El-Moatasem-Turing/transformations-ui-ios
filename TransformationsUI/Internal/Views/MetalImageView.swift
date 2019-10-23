//
//  MetalImageView.swift
//  TransformationsUI
//
//  Created by Ruben Nine on 22/10/2019.
//  Copyright © 2019 Filestack. All rights reserved.
//

import UIKit
import MetalKit
//import QuartzCore

class MetalImageView: MTKView {
    let colorSpace = CGColorSpaceCreateDeviceRGB()

    lazy var commandQueue: MTLCommandQueue? = {
        return device!.makeCommandQueue()
    }()

    lazy var ciContext: CIContext = {
        return CIContext(mtlDevice: device!)
    }()

    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device ?? MTLCreateSystemDefaultDevice())

        guard super.device != nil else {
            fatalError("Device doesn't support Metal")
        }

        isPaused = true
        enableSetNeedsDisplay = true
        framebufferOnly = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// The image to display
    var image: CIImage? {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        guard let image = image, let currentDrawable = currentDrawable else { return }
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else { return }

        let scaleX = drawableSize.width / image.extent.width
        let scaleY = drawableSize.height / image.extent.height
        let scale = min(scaleX, scaleY)

        // Scaled image
        let scaled = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        // Centered scaled image
        let centered = scaled
            .transformed(by: CGAffineTransform(translationX: (drawableSize.width - scaled.extent.width) / 2,
                                               y: (drawableSize.height - scaled.extent.height) / 2))
            .transformed(by: CGAffineTransform(translationX: -scaled.extent.origin.x,
                                               y: -scaled.extent.origin.y))
        // Composite scaled & centered image over clear background
        let compositedImage = centered.composited(over: CIImage(color: .clear))

        let destination = CIRenderDestination(width: Int(drawableSize.width),
            height: Int(drawableSize.height),
            pixelFormat: colorPixelFormat,
            commandBuffer: commandBuffer,
            mtlTextureProvider: { currentDrawable.texture }
        )

        do {
            try ciContext.startTask(toRender: compositedImage, to: destination)

            commandBuffer.present(currentDrawable)
            commandBuffer.commit()
        } catch {
            print("ERROR: Unable to render image in CoreImage context: \(error.localizedDescription)")
        }
    }
}
