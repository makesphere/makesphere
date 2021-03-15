<!--
.. title: Handleling nginx redirects
.. slug: nginx-redirects-management
.. date: 2021-03-14 15:02:30 UTC-05:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text
-->

# Nginx Tips for managing redirects in different situation

## Redirects patterns

- redirect by location, for consistent pattern
- redirect by map, for bulk redirects with a lot of non-consistent pattern
- redirect by rewrite, when not possible to use other option for any reasons, e.g., modify the `map_hash_bucket_size`

## Examples

- rewrite redirects example:

```conf
rewrite ^/tags/tags-name-1/?$    /articles/?q=&tag=tags-name-1&at= permanent;
```

- location redirects example:

```conf
; tags redirect
location ~ /tags/(.*)$ {
    ; rewrite ^ /new-name/$1?$args permanent;
    return 301 /articles/?q=&tag=$1&at=;
}

location ~ /about/(.*)$ {
    ; rewrite ^ /new-name/$1?$args permanent;
    return 301 /about-us/$1;
}
```

- map redirect example:

```conf
; nginx/common/redirects.conf

if ($redirect_uri != "none") {
    return 301 $redirect_uri;
}
```

```conf
; nginx/common/redirects-map.conf

default "none";
/tags/tag-name-1/    /articles/?q=&tag=tag-name-1&at=;
/tags/tag-name-2/    /articles/?q=&tag=tag-name-2&at=;
```

```conf
; nginx/common/server_security_settings.conf

; Redirects map settings
; map_hash_bucket_size 128; # this value needs to be written in the /etc/nginx/nginx.conf file as it warns to find a duplicate when not in the file
map $uri $redirect_uri {
    include /srv/sites/cis/etc/nginx/common/redirects-map.conf;
}
```

## Performance

That blog site, has done a very good job at testing those different redirect type performances - [https://www.dogsbody.com/blog/nginx-optimising-redirects/](https://www.dogsbody.com/blog/nginx-optimising-redirects/). The result is that for optimizing bulk redirects the map solution appears to be performing at any numbers of redirects. There is no disadvantage to set it up like that.

## Conclusion

If I can add my grain of salt to the story, I'd say to use first the redirect pattern if the use case allows it, otherwise I would use for any other cases the map pattern as it provides a possibility to scale up.

## Some tips

- check special characters
- check to add the `?$` at the end
- make use of map {} for long list of redirects (even though it uses an if statement)

## Resources and to read further

- [https://www.dogsbody.com/blog/nginx-optimising-redirects/](https://www.dogsbody.com/blog/nginx-optimising-redirects/)
- [https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#taxing-rewrites](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#taxing-rewrites)
