//
//  NSProgressBar+Extensions.swift
//  Dictater
//
//  Created by Kyle Carson on 1/25/16.
//  Copyright © 2016 Kyle Carson. All rights reserved.
//

import Foundation

extension NSProgress
{
	var percent : Double {
		guard self.totalUnitCount != 0 else {
			return 0
		}
		
		return Double(self.completedUnitCount) / Double(self.totalUnitCount)
	}
}