# Unirender
[Unirender](https://unirender.io) is a service to render a website into static HTML. It does prerendering a lot like [Prerender.com](https://prerender.com), but functions as a CDN with just a simple DNS change.

## Why

For an explanation of prerendering and why you would want it, read [this blog post](https://blog.unirender.io/content/about-server-side-rendering)

Basically, search engines do a bad job of indexing:
* SPA (Single Page Applications)
* Stuff built with UI frameworks like Vue, React, and Angular 
* Stuff loaded with AJAX

To work around that, you have a couple of options
1. There are frameworks like Nextjs/Nuxtjs and similar:
* It does not require a server, which is nice
* ... but these take time to implement


2. Stuff like [Prerender.com](https://prerender.com) is cool and all but:
* Super simple to implement
* ... but you to have a server, if even just a simple one with nginx

3. [Unirender](https://unirender.com)
* Super simple to implement
* It does not require a server. A simple DNS change is sufficient
* The api is still available if you happen to have a server. 

## How it Works

Unirender is a CDN of sorts. It does a reverse proxy on customers websites so that you can add stuff (like prerendering) to it easier. 

There are really 2 parts to it: 
* Server 1 running Rendertron. This does the prerendering
* Server 2 doing the reverse proxy, calling rendertron, doing some caching of the result
  * Since server 2 is the CDN part you would likely want to run it on a distributed platform with servers worldwide. We use [fly](https://fly.io)


## Install

For Server 1 (the rendertron server), you should simply follow the directions for setting up Rendertron. 

So far we have a docker file available for Server 2.
Before use, you should have cloned the github files into a directory called "unirender-cdn" on the target machine
Make sure your server is large enough or it may fail to install. GCE N1 will work (1 virtual CPU and 3.75 GB of memory)

When you have the docker image set up on Server 2, you should be able to access your website at https://[Server 2 ip]/https://yourwebsite.com
