# Apache Traffic Server

WIP - forward proxy configured.
 
## Usage

`docker run --rm -it -p 8080:8080 trafficserver`

## Forward Proxy

`curl` can be used to demonstrate the forward proxy is functional - 
 
```
$ curl google.com -x 0.0.0.0:8080 -vvv
* Rebuilt URL to: google.com/
*   Trying 0.0.0.0...
* Connected to 0.0.0.0 (127.0.0.1) port 8080 (#0)
> GET http://google.com/ HTTP/1.1
> Host: google.com
> User-Agent: curl/7.49.1
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
< Location: http://www.google.com/
< Content-Type: text/html; charset=UTF-8
< Date: Thu, 27 Jul 2017 14:11:39 GMT
< Expires: Sat, 26 Aug 2017 14:11:39 GMT
< Cache-Control: public, max-age=2592000
< Server: ATS/7.0.0
< Content-Length: 219
< X-XSS-Protection: 1; mode=block
< X-Frame-Options: SAMEORIGIN
< Age: 36
< Connection: keep-alive
<
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
* Connection #0 to host 0.0.0.0 left intact
$
```
