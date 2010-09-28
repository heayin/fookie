package net.fdream.io
{
	/**
	 * @Script:		Fookie.as
	 * @Licence:	MIT License (http://www.opensource.org/licenses/mit-license.php)
	 * @Author: 	xushengs@gmail.com
	 * @Website: 	http://code.google.com/p/fookie/
	 * @Version: 	0.1
	 * @Creation: 	Jan 8, 2009
	 * @Modified: 	Jan 8, 2009
	 * @Description:
	 *    This is the main class of Fookie,
	 *    Use SharedObject to save data to local
	 */
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.system.Security;

	public class Fookie {		
		/**
		 * write data to local
		 * 
	 	 * @param key
	 	 *    the key of the data
		 * @param dat
		 *    the value of the data
		 * @param app
		 *    the name of your application name,
		 *    it is the filename of data file
		 * @param path
		 *    the path of data, it means who can access the file
		 * @param exp
		 *    the number of the day(s) it will expire in
		 * @param secure
		 *    use https or not
	 	 * @return: Object
		 *    if write success, return the value saved,
		 *    else return null
		 */
		public static function writeData(key:String, dat:String, app:String, path:String, exp:Number, secure:Boolean):String {
			try {
				var so:SharedObject = SharedObject.getLocal(app, path, secure);
				var date:Date = new Date();
				date.setTime(exp * 24 * 3600 * 1000 + date.time);
				so.data[key] = dat + '|' + date.time;
				var fs:String = null;
				try {
					fs = so.flush();
					return dat;
				} catch (error:Error) {
					return null;
				}
				/*
				if (fs != null) {
					switch (fs) {
						case SharedObjectFlushStatus.PENDING :
							//trace("Requesting permission to save object...");
							//so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
							//soHandler();
							break;
						case SharedObjectFlushStatus.FLUSHED :
							//trace("Value flushed to disk.");
							break;
					}
				}
				*/
			} catch (e:Error) {
				return null;
			}
			return null;
		}
		
		/**
		 * read data from local data
		 * 
	 	 * @param key
	 	 *    the key of the data you want to read
		 * @param app
		 *    the name of your application name,
		 *   it is the filename of data file
		 * @param path
		 *   the path of data, it means who can access the file
		 * @param secure
		 *   use https or not
	 	 * @return: String
		 *    if read successfully, return the value,
		 *    else return null
		 */
		public static function readData(key:String, app:String, path:String, secure:Boolean):String {
			try {
				var so:SharedObject = SharedObject.getLocal(app, path, secure);
				var dat = so.data[key];
				// judge whether the data is expired
				if (dat) {
					dat = dat.split('|');
					if (Number(dat[dat.length - 1]) > (new Date()).time) {
						return dat.slice(0,dat.length - 1).join('');
					} else {
						delete so.data[key];
						return null;
					}
				}
				return null;
			} catch (e:Error) {
				return null;
			}
			return null;
		}

		/**
		 * remove a key/value pair from local data
		 * 
	 	 * @param key
	 	 *    the key of the data you want to remove
		 * @param app
		 *    the name of your application name,
		 *    it is the filename of data file
		 * @param path
		 *    the path of data, it means who can access the file
		 * @param secure
		 *    use https or not
	 	 * @return: Boolean
		 *    if remove successfully, return the value,
		 *    else return null
		 */
		public static function removeData(key:String, app:String, path:String, secure:Boolean):Boolean {
			try {
				var so:SharedObject = SharedObject.getLocal(app, path, secure);
				delete so.data[key];
				return true;
			} catch (e:Error) {
				return false;
			}
			return false;
		}

		/**
		 * clear all data from local
		 * 
		 * @param app
		 *    the name of your application name,
		 *    it is the filename of data file
		 * @param path
		 *    the path of data, it means who can access the file
		 * @param secure
		 *    use https or not
	 	 * @return: Boolean
		 *    if clear successfully, return the value,
		 *    else return null
		 */
		public static function clearData(app:String, path:String, secure:Boolean):Boolean {
			try {
				var so:SharedObject = SharedObject.getLocal(app, path, secure);
				so.clear();
				return true;
			} catch (e:Error) {
				return false;
			}
			return false;
		}

		/**
		 * initialize and notify javascript
		 * 
		 */
		public static function main():void {
			Security.allowDomain('*');
			Security.allowInsecureDomain('*');
			
			// add external methods for javascript
			ExternalInterface.addCallback("write", Fookie.writeData);
			ExternalInterface.addCallback("read",  Fookie.readData);
			ExternalInterface.addCallback("remove", Fookie.removeData);
			ExternalInterface.addCallback("clear", Fookie.clearData);
			
			// notify javascript that swf is ready
			ExternalInterface.call('Fookie.imReady');
		}

		public function Fookie() {
		}
	}
}