---
layout: post
title: "Cheat Sheet - Markdown editor"
author: Sandeep
categories: [ markdown, Tutorial ]
# image: assets/images/common/markdown.png
comments: false
---
There are lots of powerful things you can do with the Markdown editor. If you've gotten pretty comfortable with writing in Markdown, then you may enjoy some more advanced tips about the types of things you can do with Markdown!

## Special formatting

As well as bold and italics, you can also use some other special formatting in Markdown when the need arises, for example:

+ ~~strike through~~
+ ==highlight==
+ \*escaped characters\*


## Writing code blocks

There are two types of code elements which can be inserted in Markdown, the first is inline, and the other is block. Inline code is formatted by wrapping any word or words in back-ticks, `like this`. Larger snippets of code can be displayed across multiple lines using triple back ticks:

```
.my-link {
    text-decoration: underline;
}
```

#### HTML

```html
<li class="ml-1 mr-1">
    <a target="_blank" href="#">
    <i class="fab fa-twitter"></i>
    </a>
</li>
```

#### CSS

```css
.highlight .c {
    color: #999988;
    font-style: italic; 
}
.highlight .err {
    color: #a61717;
    background-color: #e3d2d2; 
}
```

#### JS

```js
// alertbar later
$(document).scroll(function () {
    var y = $(this).scrollTop();
    if (y > 280) {
        $('.alertbar').fadeIn();
    } else {
        $('.alertbar').fadeOut();
    }
});
```

#### Python

```python
print("Hello World")
```

#### Ruby

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```

#### C

```c
printf("Hello World");
```

![walking]({{ site.baseurl }}/assets/images/8.jpg)

## Reference lists

The quick brown jumped over the lazy.

Another way to insert links in markdown is using reference lists. You might want to use this style of linking to cite reference material in a Wikipedia-style. All of the links are listed at the end of the document, so you can maintain full separation between content and its source or reference.

## Full HTML

Perhaps the best part of Markdown is that you're never limited to just Markdown. You can write HTML directly in the Markdown editor and it will just work as HTML usually does. No limits! Here's a standard YouTube embed code as an example:

<p><iframe style="width:100%;" height="315" src="https://www.youtube.com/embed/Cniqsc9QfDo?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe></p>

Another exmple below

<figure>
  <figcaption>Source: <a href="https://kubernetespodcast.com/episode/113-instrumentation-and-cadvisor/">"Kubernetes podcast from Google #113"</a></figcaption>
  <audio style="width:100%;" height="45" controls src="https://kubernetespodcast.com/episodes/KPfGep113.mp3"></audio>
</figure>

## Highlight the code

You can use little HTML and [highlight-js](https://highlightjs.org/) to highlight the code.
Include the below lines to highlight a code with a theme.

[downlaod](https://highlightjs.org/download/) section we can find a prebuilt version of `highlight.js` with 38 commonly used languages is hosted by cdns
- cdnjs
- jsdelivr

For more coding [styles](https://github.com/highlightjs/highlight.js/tree/master/src/styles), check out `highlight.js` styles directory and don't forget to add `.min` before `.css`.

Add below 3 lines anywhere in your file. 
**vs2015** is the style that we chose to highlight our code.

More [styles](https://github.com/highlightjs/highlight.js/tree/master/src/styles) here.

```html
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/styles/vs2015.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
```

This below YAML code will look like

```yaml
---
docker:
    - image: ubuntu:14.04
    - image: mongo:2.6.8
      command: [mongod, --smallfiles]
    - image: postgres:9.4.1
```

Highlighted code below

<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/styles/vs2015.min.css">
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/10.1.1/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

<pre>sample.yaml<code>---
docker:
    - image: ubuntu:14.04
    - image: mongo:2.6.8
      command: [mongod, --smallfiles]
    - image: postgres:9.4.1
</code></pre>

## Horizontal Rule
<hr style="margin-top: -0.5em;height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

Add the below line under your header

```html
<hr style="margin-top: 0.5em;height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">
```