# about SubChecker
SubChecker is a bash script to enumerate subdomains of websites using the Public API of VirusTotal (or https://crt.sh).  
With this script you will be able to : 
- enumerate subdomains.
- checking if subdomains web server is working, used or not.
- calculate the number of days remaining before the registry expiration date (using `whois`).

# Virustotal API
https://developers.virustotal.com/reference#getting-started 
~~~
The Public API is limited to 500 requests per day and a rate of 4 requests per minute.
The Public API must not be used in commercial products, services or business workflows.
The Private API returns more threat data and exposes more endpoints.
The Private API is governed by an SLA that guarantees readiness of data.
~~~
# How it works ?
1. Enumerating subdomains (using API or crt.sh)
2. All subdomains found go through a `curl -s -m2 --head http(s)://subdomain` to check the HTTP status codes.  
If the output of this command is empty then the subdomain appear as not being used.

# Color meaning 
- Green : the web server is working (status code = 200) :+1:
- Blue : the subdomain is used (status code = [201,599] redirection, client error, server error, ...) 
- Red : the subdomain is not used :x: 

# HTTP Status Codes
~~~  
- 2×× Success
    - 200 OK
    - 201 Created
    - 202 Accepted
    - 203 Non-authoritative Information
    - 204 No Content
    - 205 Reset Content
    - 206 Partial Content
    - 207 Multi-Status
    - 208 Already Reported
    - 226 IM Used
    
- 3×× Redirection
    - 300 Multiple Choices
    - 301 Moved Permanently
    - 302 Found
    - 303 See Other
    - 304 Not Modified
    - 305 Use Proxy
    - 307 Temporary Redirect
    - 308 Permanent Redirect
    
- 4×× Client Error
    - 400 Bad Request
    - 401 Unauthorized
    - 402 Payment Required
    - 403 Forbidden
    - 404 Not Found
    - 405 Method Not Allowed
    - 406 Not Acceptable
    - 407 Proxy Authentication Required
    - 408 Request Timeout
    - 409 Conflict
    - 410 Gone
    - 411 Length Required
    - 412 Precondition Failed
    - 413 Payload Too Large
    - 414 Request-URI Too Long
    - 415 Unsupported Media Type
    - 416 Requested Range Not Satisfiable
    - 417 Expectation Failed
    - 418 I'm a teapot
    - 421 Misdirected Request
    - 422 Unprocessable Entity
    - 423 Locked
    - 424 Failed Dependency
    - 426 Upgrade Required
    - 428 Precondition Required
    - 429 Too Many Requests
    - 431 Request Header Fields Too Large
    - 444 Connection Closed Without Response
    - 451 Unavailable For Legal Reasons
    - 499 Client Closed Request
     
- 5×× Server Error
    - 500 Internal Server Error
    - 501 Not Implemented
    - 502 Bad Gateway
    - 503 Service Unavailable
    - 504 Gateway Timeout
    - 505 HTTP Version Not Supported
    - 506 Variant Also Negotiates
    - 507 Insufficient Storage
    - 508 Loop Detected
    - 510 Not Extended
    - 511 Network Authentication Required
    - 599 Network Connect Timeout Error
~~~ 
 
# Upcoming improvement 
- [ ] Add SSL certificate expiration date for subdomains.
- [ ] Make a table for easier readability. 
- [x] Add HTTP status code for each subdomain.

# Usage 
1. git clone `https://github.com/hafx/SubChecker.git`
2. Open your favourite terminal and run the script.  
`./SubChecker.sh [option] "domain"`

| Long form | Description                                                     |
|-----------|-----------------------------------------------------------------|
| --EXT     | Parsing an external HTML to find all subdomains (https://crt.sh)|
| --API     | Using the virustotal API to find all subdomains                 |



# Example 
`./SubChecker.sh --EXT github.com`  
`./SubChecker.sh --API github.com`
~~~ 
You are going to check the domain with the VirusTotal API. 
Please make sur you have copy your own api key in "apikey.txt" 
Registry expiry date  github.com : 598 days left
--------------------------------------------------------------------------------
...
http://help.github.com is used ! (status code= 301)
https://help.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://hpneo.github.com is used ! (status code= 301)
https://hpneo.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://iad.github.com is not used.❌
https://iad.github.com is not used. ❌
----------------------------------------------------------------------
http://ichord.github.com is used ! (status code= 301)
https://ichord.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://inspirit.github.com is used ! (status code= 301)
https://inspirit.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jackaudio.github.com is used ! (status code= 301)
https://jackaudio.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jackpal.github.com is used ! (status code= 301)
https://jackpal.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jamesflorentino.github.com is used ! (status code= 301)
https://jamesflorentino.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://javasoze.github.com is used ! (status code= 301)
https://javasoze.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jaymorrow.github.com is used ! (status code= 301)
https://jaymorrow.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jdewit.github.com is used ! (status code= 301)
https://jdewit.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jeromeetienne.github.com is used ! (status code= 301)
https://jeromeetienne.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jobs.github.com is used ! (status code= 301)
https://jobs.github.com is working ! (status code= 200) 👍
----------------------------------------------------------------------
http://joelpurra.github.com is used ! (status code= 301)
https://joelpurra.github.com is used ! (status code= 301)
----------------------------------------------------------------------
http://jonpauldavies.github.com is used ! (status code= 301)
https://jonpauldavies.github.com is used ! (status code= 301)
----------------------------------------------------------------------
...
~~~ 

