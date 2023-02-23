# Commands

<ul>
{% for page in site.pages %}
{% if page.title and page.title != 'Commands' and page.dir == '/docs/' %}
  <li><a href="{{ page.url | relative_url }}">{{ page.title }}</a></li>
{% endif %}
{% endfor %}
</ul>
