/*  
 * The MIT License
 *
 * Copyright (c) 2008
 * United Nations Office at Geneva
 * Center for Advanced Visual Analytics
 * http://cava.unog.ch
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package org.un.cava.birdeye.qavis.charts.series
{
	import flash.events.Event;
	
	import org.un.cava.birdeye.qavis.charts.axis.XYZAxis;
	import org.un.cava.birdeye.qavis.charts.interfaces.IStack;
	
	[Exclude(name="stackType", kind="property")] 
	[Exclude(name="total", kind="property")] 
	[Exclude(name="stackPosition", kind="property")] 
	[Exclude(name="seriesType", kind="property")] 

	public class StackableSeries extends CartesianSeries implements IStack
	{
		private const OWN_VERTICAL_INTERVAL_CHANGES:String = "is_own_vertical_listening_interval_changes"; 
		private const DATAPROVIDER_VERTICAL_INTERVAL_CHANGES:String = "is_own_horizontal_listening_interval_changes"; 
		private const OWN_HORIZONTAL_INTERVAL_CHANGES:String = "is_own_horizontal_listening_interval_changes"; 
		private const DATAPROVIDER_HORIZONTAL_INTERVAL_CHANGES:String = "is_own_dataprovider_horizontal_listening_interval_changes"; 
		
		private var isListening:Array = [];
		
		protected var deltaSize:Number;
		
		public static const OVERLAID:String = "overlaid";
		public static const STACKED:String = "stacked";
		public static const STACKED100:String = "stacked100";
		
		protected var _stackType:String = OVERLAID;
		public function set stackType(val:String):void
		{
			_stackType = val;
			invalidateProperties();
			invalidateDisplayList();
		}
		public function get stackType():String
		{
			return _stackType;
		}
		
		public var _baseValues:Array;
		public function set baseValues(val:Array):void
		{
			_baseValues = val;
			invalidateProperties();
			invalidateDisplayList();
		}
		public function get baseValues():Array
		{
			return _baseValues;
		}

		protected var _total:Number = NaN;
		public function set total(val:Number):void
		{
			_total = val;
			invalidateProperties();
			invalidateDisplayList();
		}

		protected var _stackPosition:Number = NaN;
		public function set stackPosition(val:Number):void
		{
			_stackPosition = val;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get seriesType():String
		{
			// to be overridden
			
			return null;
		}
		
		public function StackableSeries()
		{
			super();
			
			isListening [OWN_VERTICAL_INTERVAL_CHANGES] = false;
			isListening [OWN_HORIZONTAL_INTERVAL_CHANGES] = false;
			isListening [DATAPROVIDER_VERTICAL_INTERVAL_CHANGES] = false;
			isListening [DATAPROVIDER_HORIZONTAL_INTERVAL_CHANGES] = false;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (yAxis)
			{
				if (! isListening[OWN_VERTICAL_INTERVAL_CHANGES])
				{
					XYZAxis(yAxis).addEventListener("IntervalChanged", update);
					isListening[OWN_VERTICAL_INTERVAL_CHANGES] = true;
				}
				if (isListening[DATAPROVIDER_VERTICAL_INTERVAL_CHANGES])
				{
					XYZAxis(dataProvider.yAxis).removeEventListener("IntervalChanged", update);
				}
			} else if (dataProvider && dataProvider.yAxis) {
				if (! isListening[DATAPROVIDER_VERTICAL_INTERVAL_CHANGES])
				{
					XYZAxis(dataProvider.yAxis).addEventListener("IntervalChanged", update);
					isListening[DATAPROVIDER_VERTICAL_INTERVAL_CHANGES] = true;
				}
			}

			if (xAxis)
			{
				if (! isListening[OWN_HORIZONTAL_INTERVAL_CHANGES])
				{
					XYZAxis(xAxis).addEventListener("IntervalChanged", update);
					isListening[OWN_HORIZONTAL_INTERVAL_CHANGES] = true;
				}
				if (isListening[DATAPROVIDER_HORIZONTAL_INTERVAL_CHANGES])
				{
					XYZAxis(dataProvider.xAxis).removeEventListener("IntervalChanged", update);
				}
			} else if (dataProvider && dataProvider.xAxis) {
				if (! isListening[DATAPROVIDER_HORIZONTAL_INTERVAL_CHANGES])
				{
					XYZAxis(dataProvider.xAxis).addEventListener("IntervalChanged", update);
					isListening[DATAPROVIDER_HORIZONTAL_INTERVAL_CHANGES] = true;
				}
			}
			
			if (dataProvider.is3D)
				deltaSize = 1/5;
			else 
				deltaSize = 3/5;
		}
		
		private function update(e:Event):void
		{
			invalidateDisplayList();
		}
	}
}