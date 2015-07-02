Use Fookie is very easy, there are only 4 steps:

## 1. Download swf and script file ##

Download [fookie.swf](http://code.google.com/p/fookie/downloads/detail?name=fookie.swf&can=2&q=) and [fookie.js](http://code.google.com/p/fookie/downloads/detail?name=fookie-0.2-min.js&can=2&q=)


## 2. Include the script file ##

Add this line to your head tag in the page:
```
<script type="text/javascript" src="fookie.js"></script>
```
**repalce the path of the javascript file to your path**


## 3. Initialize Fookie ##

Just write a function, and then init:
```
function ready() {
    alert('Fookie is ready');
}
Fookie.init('fookie.swf', { 'onready': ready });
```
**repalce the path of the swf to your path**


## 4. Write or read data ##

Fookie supply these method for you to read and write data:

  * Fookie.read(key);
  * Fookie.write(key, value);
  * Fookie.remove(key);
  * Fookie.clear();