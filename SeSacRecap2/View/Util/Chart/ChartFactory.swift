//
//  ChartFactory.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import Foundation
import DGCharts
import CoreGraphics // 그라디언트나 컬러관리, offscreend렌더링, 쉐이딩, 이미지 데이터 관리, 이미지 생성, 이미지 마스킹 등
import UIKit

/* When drawing each bar, the renderer actually draws each bar from 0 to the required value.
                 * This drawn bar is then clipped to the visible chart rect in BarLineChartViewBase's draw(rect:) using clipDataToContent.
                 * While this works fine when calculating the bar rects for drawing, it causes the accessibilityFrames to be oversized in some cases.
                 * This offset attempts to undo that unnecessary drawing when calculating barRects
                 *
                 * +---------------------------------------------------------------+---------------------------------------------------------------+
                 * |      Situation 1:  (!inverted && y >= 0)                      |      Situation 3:  (inverted && y >= 0)                       |
                 * |                                                               |                                                               |
                 * |        y ->           +--+       <- top                       |        0 -> ---+--+---+--+------   <- top                     |
                 * |                       |//|        } topOffset = y - max       |                |  |   |//|          } topOffset = min         |
                 * |      max -> +---------+--+----+  <- top - topOffset           |      min -> +--+--+---+--+----+    <- top + topOffset         |
                 * |             |  +--+   |//|    |                               |             |  |  |   |//|    |                               |
                 * |             |  |  |   |//|    |                               |             |  +--+   |//|    |                               |
                 * |             |  |  |   |//|    |                               |             |         |//|    |                               |
                 * |      min -> +--+--+---+--+----+  <- bottom + bottomOffset     |      max -> +---------+--+----+    <- bottom - bottomOffset   |
                 * |                |  |   |//|        } bottomOffset = min        |                       |//|          } bottomOffset = y - max  |
                 * |        0 -> ---+--+---+--+-----  <- bottom                    |        y ->           +--+         <- bottom                  |
                 * |                                                               |                                                               |
                 * +---------------------------------------------------------------+---------------------------------------------------------------+
                 * |      Situation 2:  (!inverted && y < 0)                       |      Situation 4:  (inverted && y < 0)                        |
                 * |                                                               |                                                               |
                 * |        0 -> ---+--+---+--+-----   <- top                      |        y ->           +--+         <- top                     |
                 * |                |  |   |//|         } topOffset = -max         |                       |//|          } topOffset = min - y     |
                 * |      max -> +--+--+---+--+----+   <- top - topOffset          |      min -> +---------+--+----+    <- top + topOffset         |
                 * |             |  |  |   |//|    |                               |             |  +--+   |//|    |                               |
                 * |             |  +--+   |//|    |                               |             |  |  |   |//|    |                               |
                 * |             |         |//|    |                               |             |  |  |   |//|    |                               |
                 * |      min -> +---------+--+----+   <- bottom + bottomOffset    |      max -> +--+--+---+--+----+    <- bottom - bottomOffset   |
                 * |                       |//|         } bottomOffset = min - y   |                |  |   |//|          } bottomOffset = -max     |
                 * |        y ->           +--+        <- bottom                   |        0 -> ---+--+---+--+-------  <- bottom                  |
                 * |                                                               |                                                               |
                 * +---------------------------------------------------------------+---------------------------------------------------------------+
                 */

struct ChartDatasetFactory {
    func makeChartDataset(
        colorAsset: ColorEssets,
        entries: [ChartDataEntry]
    ) -> LineChartDataSet {
        var dataSet = LineChartDataSet(entries: entries, label: "")

        // chart main settings
        dataSet.setColor(colorAsset.color)
        dataSet.lineWidth = 3
        dataSet.mode = .cubicBezier // 둥글기
        dataSet.drawValuesEnabled = false // disble values
        dataSet.drawCirclesEnabled = false // 동글뱅이 제거
        dataSet.drawFilledEnabled = true // gradient setting

        // settings for picking values on graph
        dataSet.drawHorizontalHighlightIndicatorEnabled = false 
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        
        dataSet.highlightLineWidth = 1// vertical line width
        
        dataSet.highlightColor = colorAsset.color // vertical line color

        addGradient(to: &dataSet, colorAsset: colorAsset)

        return dataSet
    }
}


private extension ChartDatasetFactory {
    
    
    // inout이 뭐야? 매개변수를 받아서 그놈을 바꿀꺼야 하지만 그놈은
    // &라는 딱지를 붙여
    func addGradient(
        to dataSet: inout LineChartDataSet,
        colorAsset: ColorEssets
    ) {
        let mainColor = colorAsset.color.withAlphaComponent(0.9)
        let secondaryColor = colorAsset.color.withAlphaComponent(0.5)  // colorAsset.color.withAlphaComponent(0.8)
        let fore = colorAsset.color.withAlphaComponent(0)// colorAsset.color.withAlphaComponent(0)
        let colors = [
            mainColor.cgColor,
            secondaryColor.cgColor,
            fore.cgColor
        ] as CFArray
        
        let locations: [CGFloat] = [0, 0.79, 1]
        if let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors,
            locations: locations
        ) {
            print(UIScreen.main.bounds.width / 2)
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: UIScreen.main.bounds.width / 2)
        }
    }
}
