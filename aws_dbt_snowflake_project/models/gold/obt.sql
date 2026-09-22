{# Definition - this is a list of configurations for the tables to be joined,
basically an array having bunch of dictionaries 
A metadata driven approach  - an approach where the structure and
behavior of the data models are defined by metadata rather than hardcoded logic #}
{% set configs = [
    {
        "table" : "AIRBNB.SILVER.SILVER_BOOKINGS",
        "columns" : "SILVER_bookings.*",
        "alias" : "SILVER_bookings"
    },
    { 
        "table" : "AIRBNB.SILVER.SILVER_LISTINGS",
        "columns" : "SILVER_listings.HOST_ID, SILVER_listings.PROPERTY_TYPE, SILVER_listings.ROOM_TYPE, SILVER_listings.CITY, SILVER_listings.COUNTRY, SILVER_listings.ACCOMMODATES, SILVER_listings.BEDROOMS, SILVER_listings.BATHROOMS, SILVER_listings.PRICE_PER_NIGHT, silver_listings.PRICE_PER_NIGHT_TAG, SILVER_listings.CREATED_AT AS LISTING_CREATED_AT",
        "alias" : "SILVER_listings",
        "join_condition" : "SILVER_bookings.listing_id = SILVER_listings.listing_id"
    },
    {
        "table" : "AIRBNB.SILVER.SILVER_HOSTS",
        "columns" : "SILVER_hosts.HOST_NAME, SILVER_hosts.HOST_SINCE, SILVER_hosts.IS_SUPERHOST, SILVER_hosts.RESPONSE_RATE, SILVER_hosts.RESPONSE_RATE_QUALITY, SILVER_hosts.CREATED_AT AS HOST_CREATED_AT",
        "alias" : "SILVER_hosts",
        "join_condition" : "SILVER_listings.host_id = SILVER_hosts.host_id"
    }
] %}


{# Dynamic Query - we will iterate through the configurations to build the SELECT and FROM clauses 
    this query remains dynamic or constant based on the configurations,
    means we do not need to change the query if we want to add or remove a table from the join,
    if we require changes or additions to the joined tables, we can simply modify the configurations array
    this is called metadata-driven development or pipeline
    this thing is not mentioned in dbt documentation #}

SELECT 
    {% for config in configs %}
        {{ config['columns'] }}{% if not loop.last %},{% endif %}
    {% endfor %}
FROM
    {% for config in configs %}
    {% if loop.first %}
      {{ config['table'] }} AS {{ config['alias'] }}
    {% else %}
        LEFT JOIN {{ config['table'] }} AS {{ config['alias'] }}
        ON {{ config['join_condition'] }}
        {% endif %}
        {% endfor %}