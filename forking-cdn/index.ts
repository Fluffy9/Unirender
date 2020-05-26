import { backends, middleware, pipeline } from "@fly/edge";

// user middleware for https redirect and caching
const mw = pipeline(
  middleware.httpsUpgrader,
  middleware.httpCache
)

// point it at the origin
const app = mw(
  backends.origin("https://unirender.appspot.com/render/")
);

// respond to http requests
fly.http.respondWith(app);