This is the commandline program that does the heavy lifting for NS_Text_Exporter.  The major reason for splitting the program into a GUI and backend was to _easily_ take advantage of multiple processors all exporting a file, without having to do my own threading.  

I believe this was under Mac OS X 10.5, via NSOperation.  

I also later discovered that when doing a ton of exports, I really liked the command-line only interface!
