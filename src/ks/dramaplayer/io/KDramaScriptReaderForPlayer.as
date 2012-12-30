package ks.dramaplayer.io
{
	import ks.dramaplayer.data.*;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import ks.dramaplayer.tlevent.KPauseEvent;
	import ks.dramaplayer.tlevent.KPauseMainEvent;
	import ks.dramaplayer.tlevent.KResumeEvent;
	import ks.dramaplayer.tlevent.KResumeMainEvent;

	public class KDramaScriptReaderForPlayer implements IKDramaScriptReader
	{
		private var _stream:FileStream = new FileStream();
		private var _data:KDramaData = null;
		private var _callback:Function = null;
		
		private static const SPACE:String = "\\s*";
		private static const NUMBER:String = "[0-9]+";
		private static const VARIBEL:String = "[_a-zA-Z][_a-zA-Z0-9]*";
		private static const LB:String = "\\(";
		private static const RB:String = "\\)";
		private static const DOT:String = "\\.";
		private static const COMMA_SEP:String = SPACE + "," + SPACE;
		private static const ANY:String = ".*";
		
		// $actor = newActor($source)
		private static const NEW:String = "^(" + VARIBEL + ")"
			+ SPACE + "=" + SPACE
			+ "newActor" + SPACE + LB + SPACE
			+ "("+ ANY +")"
			+ SPACE + RB;
		private static const NEW_REG:RegExp = new RegExp(NEW);
		
		// $actor.setKeyFrame($frame, $attribute, $value, $interpolation)
		private static const SET:String = "^(" + VARIBEL + ")" 
			+ SPACE + DOT + SPACE
			+ "setKeyFrame" + SPACE + LB + SPACE
			+ "(" + NUMBER + ")"
			+ COMMA_SEP
			+ "(" + VARIBEL + ")"
			+ COMMA_SEP
			+ "(" + VARIBEL + "|" + NUMBER + ")"
			+ COMMA_SEP
			+ "(" + VARIBEL + ")"
			+ SPACE + RB;
		private static const SET_RE:RegExp = new RegExp(SET);
		
		// ($frame, $trigger, $condition)
		private static const EVENT_PARAMS:String = 
			SPACE + LB + SPACE
			+ "(" + NUMBER + ")"
			+ COMMA_SEP
			+ "(" + ANY + ")"
			+ COMMA_SEP
			+ "(" + ANY + ")"
			+ SPACE + RB;
		
		// $actor.pause($frame, $trigger, $condition)
		private static const PAUSE:String = "^(" + VARIBEL + ")"
			+ SPACE + DOT + SPACE
			+ "pause"
			+ EVENT_PARAMS;
		private static const PAUSE_RE:RegExp = new RegExp(PAUSE);
			
		// $actor.resume($frame, $trigger, $condition)
		private static const RESUME:String = "^(" + VARIBEL + ")"
			+ SPACE + DOT + SPACE
			+ "resume"
			+ EVENT_PARAMS;
		private static const RESUME_RE:RegExp = new RegExp(RESUME);
			
		// $actor.pause_main($frame, $trigger, $condition)
		private static const PAUSE_MAIN:String = "^(" + VARIBEL + ")"
			+ SPACE + DOT + SPACE
			+ "pause_main"
			+ EVENT_PARAMS;
		private static const PAUSE_MAIN_RE:RegExp = new RegExp(PAUSE_MAIN);
			
		// $actor.resume_main($frame, $trigger, $condition)
		private static const RESUME_MAIN:String = "^(" + VARIBEL + ")"
			+ SPACE + DOT + SPACE
			+ "resume_main"
			+ EVENT_PARAMS;
		private static const RESUME_MAIN_RE:RegExp = new RegExp(RESUME_MAIN);
			
		
		public function KDramaScriptReaderForPlayer(complete:Function = null)
		{
			_callback = complete;
		}
		
		public function readScript(path:String, dData:KDramaData):void
		{
			_data = dData;
			var file:File = new File(path);
			_stream.addEventListener(Event.COMPLETE, onReadComplete);
			_stream.openAsync(file, FileMode.READ);
		}
		
		private function onReadComplete(event:Event):void
		{
			var raw:String = _stream.readUTFBytes(_stream.bytesAvailable);
			var lines:Array = raw.split(/\n/);
			for each (var line:String in lines)
			{
				line = trim(line);
				if (!isEmptyLineOrComments(line))
				{
					var deal:Boolean = false;
					if (!deal)
					{
						deal = parseNew(line);
					}
					if (!deal)
					{
						deal = parseSet(line);
					}
					if (!deal)
					{
						deal = parsePause(line);
					}
					if (!deal)
					{
						deal = parseResume(line);
					}
					if (!deal)
					{
						deal = parsePauseMain(line);
					}
					if (!deal)
					{
						deal = parseResumeMain(line);
					}
				}
			}
			
			_data = null;
			if (_callback != null)
			{
				_callback();
			}
		}
		
		private function trim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pat:RegExp = /^\s+/;
			char = char.replace(pat, "");
			pat = /\s+$/;
			char = char.replace(pat, "");
			return char;
		}
		
		private function isEmptyLineOrComments(line:String):Boolean
		{
			return line.length < 1 || line.charAt(0) == "#";
		}
		
		private function parseNew(line:String):Boolean
		{
			var result:Array = line.match(NEW_REG);
			if (result != null)
			{
				trace(result);
				var actLabel:String = result[1];
				var source:String = result[2];
				_data.createActor(actLabel, source);
				return true;
			}
			return false;
		}
		
		private function parseSet(line:String):Boolean
		{
			var result:Array = line.match(SET_RE);
			if (result != null)
			{
				trace(result);
				var actLabel:String = result[1];
				var frame:int = parseInt(result[2]);
				var attrLabel:String = result[3];
				var value:* = result[4];
				var itplLabel:String = result[5];
				var actData:KActorData = _data.getAcotr(actLabel);
				actData.putKeyFrameAttribute(frame, attrLabel, value);
				var itplFunc:Function = KInterpolationFunction.func(itplLabel);
				if (itplFunc != null)
				{
					actData.setKeyFrameInterpolation(frame, itplFunc);
				}
				return true;
			}
				
			return false;
		}
		
		private function parsePause(line:String):Boolean
		{
			var result:Array = line.match(PAUSE_RE);
			if (result != null)
			{
				trace(result);
				var actLabel:String = result[1];
				var frame:int = parseInt(result[2]);
				var trigger:String = result[3];
				var condition:String = result[4];
				var event:KPauseEvent = new KPauseEvent();
				event.trigger = trigger;
				event.condition = condition;
				var actData:KActorData = _data.getAcotr(actLabel);
				actData.setKeyFrameEvent(frame, event);
				return true;
			}
			return false;
		}
		
		private function parseResume(line:String):Boolean
		{
			var result:Array = line.match(RESUME_RE);
			if (result != null)
			{
				trace(result);
				var actLabel:String = result[1];
				var frame:int = parseInt(result[2]);
				var trigger:String = result[3];
				var condition:String = result[4];
				var event:KResumeEvent = new KResumeEvent ();
				event.trigger = trigger;
				event.condition = condition;
				var actData:KActorData = _data.getAcotr(actLabel);
				actData.setKeyFrameEvent(frame, event);
				return true;
			}
			return false;
		}
		
		private function parsePauseMain(line:String):Boolean
		{
			var result:Array = line.match(PAUSE_MAIN_RE);
			if (result != null)
			{
				trace(result);
				var actLabel:String = result[1];
				var frame:int = parseInt(result[2]);
				var trigger:String = result[3];
				var condition:String = result[4];
				var event:KPauseMainEvent = new KPauseMainEvent();
				event.trigger = trigger;
				event.condition = condition;
				var actData:KActorData = _data.getAcotr(actLabel);
				actData.setKeyFrameEvent(frame, event);
				return true;
			}
			return false;
		}
		
		private function parseResumeMain(line:String):Boolean
		{
			var result:Array = line.match(RESUME_MAIN_RE);
			if (result != null)
			{
				trace(result);
				var actLabel:String = result[1];
				var frame:int = parseInt(result[2]);
				var trigger:String = result[3];
				var condition:String = result[4];
				var event:KResumeMainEvent = new KResumeMainEvent ();
				event.trigger = trigger;
				event.condition = condition;
				var actData:KActorData = _data.getAcotr(actLabel);
				actData.setKeyFrameEvent(frame, event);
				return true;
			}
			return false;
		}
	}
}