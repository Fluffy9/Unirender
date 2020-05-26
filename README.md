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
* **Server 1**: running Rendertron. This does the prerendering
* **Server 2**: performing the reverse proxy, calling rendertron, doing some caching of the result
  * Since server 2 is the CDN part you would likely want to run it on a distributed platform with servers worldwide. We use [fly](https://fly.io)


## Install

### Step 1 | Set Up Rendertron

For **Server 1** (the rendertron server), you should simply follow the directions for setting up [Rendertron](https://github.com/GoogleChrome/rendertron). 

So far we have a docker file available for **Server 2**.

### Step 2 | Set Up Files

Acquire at least one other server. Make sure this server is large enough or the dockerfile may fail. GCE N1 will work (1 virtual CPU and 3.75 GB of memory)

Before use, you should have cloned this source to the target machine. There should be a folder called "unirender-cdn" on the your target machine. This folder should be next to the Dockerfile as the Dockerfile pulls files from there.

Open the "unirender-cdn" folder and there should be a file called index.ts. Replace the backend URL with the URL of your Rendertron server 

`
...

// point it at the origin
const app = mw(
 backends.origin(https://[your-rendertron-url].com/render/)
);

...

` 
#### Alternate | Limit to a single domain

If you want the CDN to work only for a certain domain, add that to the url path like so: 

```
...

// point it at the origin

const app = mw(
 backends.origin([https://your-rendertron-url.com]/render/[https://mywebsite.com]/)
);

...

```

### Step 3 | Build and Run the Dockerfile

Enter the directory with the Dockerfile and the "unirender-cdn" folder. Run: 
```
docker build -t "unirender" .
```
Then run the newly created image with:
```
docker run -it --rm unirender
```
This will run the container in interactive mode, and when you exit the container it will automatically delete itself. 
Nodejs runs on port 3000 by default so the Dockerfile is set to run unirender on port 3000. This is correct behavior if your server is with [fly](https://fly.io). Otherwise, you may want to map that to port 80:
```
docker run -it -p 127.0.0.1:3000:80 --rm unirender
```
When you have the docker image set up on Server 2, you should be able to access something at:

* https://[Server 2]/ if you set up the server to map to **port 80, your domain only**
* https://[Server 2]:3000/ if you set up the server to map to **port 3000, your domain only**

* https://[Server 2]/[https://domain.com] if you set up the server to map to **port 80, any domain**
* https://[Server 2]:3000/[https://domain.com] if you set up the server to map to **port 3000, any domain**

### Step 4 | Optional (DNS)
 
Change your DNS settings to use your domain on **Server 2**

Most simply you would have 1 server running the unirender: 

Go to your DNS settings and add an A record pointing to **Server 2** ip address.
