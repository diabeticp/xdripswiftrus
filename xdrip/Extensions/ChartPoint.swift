import Foundation
import SwiftCharts

extension ChartPoint {
    
    convenience init(bgReading: BgReading, formatter: DateFormatter, unitIsMgDl: Bool) {
        
            self.init(
                x: ChartAxisValueDate(date: bgReading.timeStamp, formatter: formatter),
                y: ChartAxisValueDouble(bgReading.calculatedValue.mgdlToMmol(mgdl: unitIsMgDl))
            )

    }
    
    convenience init(calibration: Calibration, formatter: DateFormatter, unitIsMgDl: Bool) {
        
            self.init(
                x: ChartAxisValueDate(date: calibration.timeStamp, formatter: formatter),
                y: ChartAxisValueDouble(calibration.bg.mgdlToMmol(mgdl: unitIsMgDl))
            )

    }
    
    /// the chartpoints defined for bolus treatment entries are abolute-positioned in the chart and need to be scaled to fit the y-axis values of the glucose chart points (and therefore avoid needing a secondary axis). The offset from the bottom of the chart and the scale is pulled from the Treatment Type.
    convenience init(treatmentEntry: TreatmentEntry, formatter: DateFormatter) {
        
        let scaledValue = ConstantsGlucoseChart.absoluteMinimumChartValueInMgdl.mgdlToMmol(mgdl: UserDefaults.standard.bloodGlucoseUnitIsMgDl) + treatmentEntry.treatmentType.chartPointYAxisOffset() + (treatmentEntry.value * treatmentEntry.treatmentType.chartPointYAxisScaleFactor())
        
        self.init(
            x: ChartAxisValueDate(date: treatmentEntry.date, formatter: formatter),
            y: ChartAxisValueDouble(scaledValue)
        )

    }
    
    /// the chartpoints defined for certain treatment entries (such as carbs) are positioned relative to other elements and need to be re-scaled to fit the y-axis values of the glucose chart points (and therefore avoid needing a secondary axis)
    convenience init(treatmentEntry: TreatmentEntry, formatter: DateFormatter, newYAxisValue: Double? = 0) {
        
        var yAxisValue: Double = treatmentEntry.value
        
        // if a new Y axis value exists, use this to set the chartpoint.y value. If not, just use  treatment.value
        if let value = newYAxisValue {
            yAxisValue = value
        }
        
        self.init(
            x: ChartAxisValueDate(date: treatmentEntry.date, formatter: formatter),
            y: ChartAxisValueDouble(yAxisValue.mgdlToMmol(mgdl: UserDefaults.standard.bloodGlucoseUnitIsMgDl))
        )

    }
    
}

extension ChartPoint: Comparable {
    
    public static func < (lhs: ChartPoint, rhs: ChartPoint) -> Bool {
        
        if let lhs = lhs.x as? ChartAxisValueDate, let rhs = rhs.x as? ChartAxisValueDate {
            
            return lhs.date < rhs.date
            
        }
        
        return false
        
    }
    
    public static func == (lhs: ChartPoint, rhs: ChartPoint) -> Bool {
        
        if let lhs = lhs.x as? ChartAxisValueDate, let rhs = rhs.x as? ChartAxisValueDate {
            
            return lhs.date == rhs.date
            
        }
        
        return false
        
    }

}
